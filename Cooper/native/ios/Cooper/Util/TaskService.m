//
//  TaskService.m
//  Cooper
//
//  Created by sunleepy on 12-7-6.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskService.h"
#import "ChangeLog.h"
#import "TaskIdx.h"
#import "SBJsonParser.h"
#import "SBJsonWriter.h"

@implementation TaskService

+ (void)testUrl:(id)delegate
{

}

+ (void)getTasks:(NSString*)tasklistId delegate:(id)delegate 
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:TASK_URL_GETBYPRIORITY];
    NSLog(@"获取按优先级任务数据URL:%@", url);
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:tasklistId forKey:@"tasklistId"];
    
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:nil addHeaders:nil];
}

+ (void)syncTasks:(NSString*)tasklistId 
       changeLogs:(NSMutableArray *)changeLogs 
         taskIdxs:(NSMutableArray *)taskIdxs 
         delegate:(id)delegate
{
    NSMutableArray *changeLogsArray = [NSMutableArray array];
    for(ChangeLog *changeLog in changeLogs)
    {
        NSLog(@"changeLog:%@", changeLog.dataid);
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:changeLog.changeType forKey:@"Type"];
        [dict setObject:changeLog.dataid forKey:@"ID"];
        [dict setObject:(changeLog.name == nil ? @"" : changeLog.name)forKey:@"Name"];
        [dict setObject:(changeLog.value == nil ? @"" : changeLog.value) forKey:@"Value"];
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
    //TODO:list
    [data setObject:@"ByPriority" forKey:@"by"];
    [data setObject:taskIdxsJson forKey:@"sorts"];
    
    
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:TASK_URL_SYNC];
    NSLog(@"同步数据路径:%@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:nil addHeaders:nil];
}

+ (void)syncTask:(NSString*)tasklistId delegate:(id)delegate
{
    //TODO:...
    ChangeLogDao *changeLogDao = [[ChangeLogDao alloc] init];
    TaskIdxDao *taskIdxDao = [[TaskIdxDao alloc] init];
    NSMutableArray *changeLogs = [changeLogDao getAllChangeLog:tasklistId];
    NSLog("changeLog count: %d", changeLogs.count);
    
    NSMutableArray *taskIdxs = [taskIdxDao getAllTaskIdx:tasklistId];
    
    [TaskService syncTasks:tasklistId changeLogs:changeLogs taskIdxs:taskIdxs delegate:delegate];
    
    //[changeLogDao release];
    //[taskIdxDao release];
}

@end
