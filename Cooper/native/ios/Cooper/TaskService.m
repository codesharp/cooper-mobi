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

+ (void)getTasks:(id)delegate {
    NSString *url = [[[Constant instance] path] stringByAppendingFormat:TASK_URL_GETBYPRIORITY];
    NSLog(@"url:%@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:nil WithInfo:nil];
}

+ (void)syncTasks:(NSMutableArray *)changeLogs taskIdxs:(NSMutableArray *)taskIdxs delegate:(id)delegate
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
    [data setObject:changeLogsJson forKey:@"changes"];
    [data setObject:@"ByPriority" forKey:@"by"];
    [data setObject:taskIdxsJson forKey:@"sorts"];
    
    NSString *url = [[[Constant instance] path] stringByAppendingFormat:TASK_URL_SYNC];
    NSLog(@"urlsync:%@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:nil];
}

+ (void)syncTask:(id)delegate
{
    ChangeLogDao *changeLogDao = [[ChangeLogDao alloc] init];
    TaskIdxDao *taskIdxDao = [[TaskIdxDao alloc] init];
    NSMutableArray *changeLogs = [changeLogDao getAllChangeLog];
    NSLog("changeLog count: %d", changeLogs.count);
    
    NSMutableArray *taskIdxs = [taskIdxDao getAllTaskIdx];
    
    //sync data to server.
    [TaskService syncTasks:changeLogs taskIdxs:taskIdxs delegate:delegate];
    
    //[changeLogDao release];
    //[taskIdxDao release];
}

@end
