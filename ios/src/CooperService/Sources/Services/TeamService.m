//
//  TeamService.m
//  CooperService
//
//  Created by sunleepy on 12-9-14.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TeamService.h"
#import "SBJsonParser.h"
#import "SBJsonWriter.h"
#import "CooperCore/ChangeLog.h"
#import "CooperCore/TaskIdx.h"
#import "CooperRepository/ChangeLogDao.h"

@implementation TeamService

- (void)getTeams:(NSMutableDictionary *)context
        delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:GETTEAMS_URL];
    NSLog(@"getTeams服务路径: %@", url);
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request getAsync:url params:nil headers:nil context:context delegate:delegate];
    [request release];
}
- (void)syncTasks:(NSString*)teamId
        projectId:(NSString*)projectId
         memberId:(NSString*)memberId
              tag:(NSString*)tag
          context:(NSMutableDictionary*)context
         delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:TEAMTASK_SYNC_URL];
    NSLog(@"syncTasks服务路径: %@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:teamId forKey:@"teamId"];
//    if (projectId != nil)
//    {
//        [params setObject:projectId forKey:@"projectId"];
//    }
//    if (memberId != nil)
//    {
//        [params setObject:memberId forKey:@"memberId"];
//    }
//    if (tag != nil)
//    {
//        [params setObject:tag forKey:@"tag"];
//    }
    
    ChangeLogDao *changeLogDao = [[ChangeLogDao alloc] init];

    NSMutableArray *changeLogs = [changeLogDao getChangeLogByTeam:teamId projectId:projectId memberId:memberId tag:tag];

    NSMutableArray *changeLogsArray = [NSMutableArray array];
    for(ChangeLog *changeLog in changeLogs)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:changeLog.changeType forKey:@"Type"];
        [dict setObject:changeLog.dataId forKey:@"ID"];
        [dict setObject:(changeLog.name == nil ? @"" : changeLog.name) forKey:@"Name"];
        if([changeLog.name isEqualToString:@"isCompleted"])
        {
            [dict setObject:changeLog.value forKey:@"Value"];
        }
        else
        {
            [dict setObject:(changeLog.value == nil ? @"" : changeLog.value) forKey:@"Value"];
        }
        [changeLogsArray addObject:dict];
    }

    [changeLogDao release];

    SBJsonParser *parser = [[SBJsonParser alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];

    NSMutableArray *taskIdxsArray = [NSMutableArray array];
//    for(TaskIdx *taskIdx in taskIdxs)
//    {
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict setObject:taskIdx.by forKey:@"By"];
//        [dict setObject:taskIdx.key forKey:@"Key"];
//        [dict setObject:taskIdx.name forKey:@"Name"];
//        
//        NSMutableArray *indexsArray = nil;
//        if(!taskIdx.indexes)
//            indexsArray = [NSMutableArray array];
//        else {
//            indexsArray = [parser objectWithString:taskIdx.indexes];
//        }
//        
//        [dict setObject:indexsArray forKey:@"Indexs"];
//        [taskIdxsArray addObject:dict];
//    }

    NSString* changeLogsJson = [changeLogsArray JSONRepresentation];
    NSString* taskIdxsJson = [taskIdxsArray JSONRepresentation];

    NSLog(@"changeLogs:%@", changeLogsJson);
    NSLog(@"taskIdxs:%@", taskIdxsJson);

    [parser release];
    [writer release];

    [params setObject:changeLogsJson forKey:@"changes"];
    [params setObject:@"ByPriority" forKey:@"by"];
    [params setObject:taskIdxsJson forKey:@"sorts"];

    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}
- (void)getTasks:(NSString*)teamId
       projectId:(NSString*)projectId
        memberId:(NSString*)memberId
             tag:(NSString*)tag
         context:(NSMutableDictionary*)context
        delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:TeamTask_GETINCOMPLETEDBYPRIORITY_URL];
    NSLog(@"getIncompletedByPriority服务路径: %@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:teamId forKey:@"teamId"];
    if (projectId != nil)
    {
        [params setObject:projectId forKey:@"projectId"];
    }
    if (memberId != nil)
    {
        [params setObject:memberId forKey:@"memberId"];
    }
    if (tag != nil)
    {
        [params setObject:tag forKey:@"tag"];
    }
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}

@end
