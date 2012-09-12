//
//  TaskService.m
//  Cooper
//
//  Created by sunleepy on 12-7-6.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskService.h"
#import "CooperCore/ChangeLog.h"
#import "CooperCore/TaskIdx.h"
#import "SBJsonParser.h"
#import "SBJsonWriter.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/TaskIdxDao.h"
#import "CooperRepository/ChangeLogDao.h"

@implementation TaskService

+ (void)getTasks:(NSString*)tasklistId context:(NSMutableDictionary*)context delegate:(id)delegate 
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:TASK_GETBYPRIORITY_URL];
    NSLog(@"获取按优先级任务数据URL:%@", url);
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:tasklistId forKey:@"tasklistId"];
    
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:context addHeaders:nil];
}

+ (void)syncTasks:(NSString*)tasklistId 
       changeLogs:(NSMutableArray *)changeLogs 
         taskIdxs:(NSMutableArray *)taskIdxs 
          context:(NSMutableDictionary*)context
         delegate:(id)delegate
{
    NSMutableArray *changeLogsArray = [NSMutableArray array];
    for(ChangeLog *changeLog in changeLogs)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:changeLog.changeType forKey:@"Type"];
        [dict setObject:changeLog.dataid forKey:@"ID"];
        [dict setObject:(changeLog.name == nil ? @"" : changeLog.name)forKey:@"Name"];
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
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    
    NSMutableArray *taskIdxsArray = [NSMutableArray array];
    for(TaskIdx *taskIdx in taskIdxs)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:taskIdx.by forKey:@"By"];
        [dict setObject:taskIdx.key forKey:@"Key"];
        [dict setObject:taskIdx.name forKey:@"Name"];
        
        NSMutableArray *indexsArray = nil;
        if(!taskIdx.indexes)
            indexsArray = [NSMutableArray array];
        else {
            indexsArray = [parser objectWithString:taskIdx.indexes];
        }
        
        [dict setObject:indexsArray forKey:@"Indexs"];
        [taskIdxsArray addObject:dict];
    }
    
    NSString* changeLogsJson = [changeLogsArray JSONRepresentation];
    NSString* taskIdxsJson = [taskIdxsArray JSONRepresentation];
    
    NSLog(@"changeLogs:%@", changeLogsJson);
    NSLog(@"taskIdxs:%@", taskIdxsJson);
    
    [parser release];
    [writer release];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:tasklistId forKey:@"tasklistId"];
    [data setObject:changeLogsJson forKey:@"changes"];
    [data setObject:@"ByPriority" forKey:@"by"];
    [data setObject:taskIdxsJson forKey:@"sorts"];
    
    
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:TASK_SYNC_URL];
    NSLog(@"同步数据路径:%@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:context addHeaders:nil];
}

+ (void)syncTask:(NSString*)tasklistId 
        context:(NSMutableDictionary*)context
        delegate:(id)delegate
{
    ChangeLogDao *changeLogDao = [[ChangeLogDao alloc] init];
    TaskIdxDao *taskIdxDao = [[TaskIdxDao alloc] init];
    
    NSMutableArray *changeLogs = [changeLogDao getAllChangeLog:tasklistId];
    NSLog("改变记录总数: %d", changeLogs.count);
    
    NSMutableArray *taskIdxs = nil;
    if([[[ConstantClass instance] sortHasChanged] isEqualToString:@"true"])
    {
        taskIdxs = [taskIdxDao getAllTaskIdx:tasklistId];
    }
    else
    {
        taskIdxs = [NSMutableArray array];
    }
    
    [changeLogDao release];
    [taskIdxDao release];
    
    [TaskService syncTasks:tasklistId changeLogs:changeLogs taskIdxs:taskIdxs context:context delegate:delegate];
}

+ (void)syncTaskByDict:(NSMutableDictionary *)dictionary delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:TASK_SYNC_URL];
    NSLog(@"同步数据路径:%@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:dictionary WithInfo:nil addHeaders:nil];
}

@end
