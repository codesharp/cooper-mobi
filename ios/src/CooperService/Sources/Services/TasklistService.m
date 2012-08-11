//
//  TasklistService.m
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TasklistService.h"
#import "CooperRepository/TasklistDao.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/TaskIdxDao.h"
#import "CooperRepository/ChangeLogDao.h"

@implementation TasklistService

+ (NSString*)syncTasklist:(NSString*)name :(NSString*)type :(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:CREATETASKLIST_URL];
    NSLog(@"syncTasklist外部路径: %@", url);
 
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:name forKey:@"name"];
    [data setObject:type forKey:@"type"];
    
    //NSString *result = [NetworkManager doSynchronousPostRequest:url data:data];
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:nil addHeaders:nil];
    return @"";
}

+ (void)syncTasklists:(NSMutableDictionary*)context delegate:(id)delegate
{
    TasklistDao *tasklistDao = [[TasklistDao alloc] init];
    TaskDao *taskDao = [[TaskDao alloc] init];
    TaskIdxDao *taskIdxDao = [[TaskIdxDao alloc] init];
    ChangeLogDao *changeLogDao = [[ChangeLogDao alloc] init];
    
    NSMutableArray *tempTasklists = [tasklistDao getAllTasklistByTemp];
    
    if([[ConstantClass instance] username].length > 0)
    {    
        NSMutableArray *tasklists = [tasklistDao getAllTasklistByUserAndTemp];
        [tempTasklists addObjectsFromArray:tasklists];
        
        //HACK:表中相关的用户设置
        for(Tasklist *temp in tempTasklists) {
            temp.accountId = [[ConstantClass instance] username];
        }
        
        NSMutableArray *tempTasks = [taskDao getAllTaskByTemp];
        for (Task *temp in tempTasks) {
            temp.accountId = [[ConstantClass instance] username];
        }
        
        NSMutableArray *tempTaskIdxs = [taskIdxDao getAllTaskIdxByTemp];
        for (TaskIdx *temp in tempTaskIdxs) {
            temp.accountId = [[ConstantClass instance] username];
        }
        
        NSMutableArray *tempChangeLogs = [changeLogDao getAllChangeLogByTemp];
        for (TaskIdx *temp in tempChangeLogs) {
            temp.accountId = [[ConstantClass instance] username];
        }
         
        [tasklistDao commitData];
    }
     
    NSMutableArray *array = [NSMutableArray array];
    for (Tasklist *tasklist in tempTasklists)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:tasklist.id forKey:@"ID"];
        [dict setObject:tasklist.name forKey:@"Name"];
        [dict setObject:tasklist.listType forKey:@"Type"];
        [array addObject:dict];
    }
    
    NSString *tasklistsJson = [array JSONRepresentation];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:tasklistsJson forKey:@"data"];
    
    [changeLogDao release];
    [taskIdxDao release];
    [taskDao release];
    [tasklistDao release];
    
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:TASKLISTS_SYNC_URL];
    NSLog(@"同步所有的任务列表外部路径: %@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:context addHeaders:nil];
}

+ (void)getTasklists:(NSMutableDictionary*)context 
            delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:GETTASKLISTS_URL];
    NSLog(@"getTasklists外部路径: %@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:nil WithInfo:context addHeaders:nil];
}

@end
