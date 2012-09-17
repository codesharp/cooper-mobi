//
//  TaskNewService.m
//  CooperService
//
//  Created by sunleepy on 12-9-8.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskNewService.h"
#import "CooperCore/Tasklist.h"
#import "CooperCore/ChangeLog.h"
#import "CooperCore/TaskIdx.h"
#import "SBJsonParser.h"
#import "SBJsonWriter.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/TaskIdxDao.h"
#import "CooperRepository/ChangeLogDao.h"

@implementation TaskNewService

- (void)getAllTasks:(NSMutableArray*)tasklists
            context:(NSMutableDictionary*)context
              queue:(ASINetworkQueue*)networkQueue
           delegate:(id)delegate
{
    networkQueue.delegate = delegate;
    networkQueue.queueDidFinishSelector = @selector(queueFinished:);
    networkQueue.requestDidFinishSelector = @selector(requestFinished:);
    networkQueue.requestDidFailSelector = @selector(requestFailed:);
    
    NSMutableDictionary *queueContext = [NSMutableDictionary dictionary];
    [queueContext setObject:[context objectForKey:REQUEST_TYPE] forKey:REQUEST_TYPE];
    networkQueue.userInfo = queueContext;
    
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:TASK_GETBYPRIORITY_URL];
    NSLog(@"获取按优先级任务数据URL:%@", url);
    
    for (Tasklist *tasklist in tasklists)
    {
        NSString *tasklistId = tasklist.id;
        
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        [data setObject:tasklistId forKey:@"tasklistId"];
        
        HttpWebRequest *request = [[HttpWebRequest alloc] init];
        NSMutableDictionary *context1 = [NSMutableDictionary dictionary];
        [context1 setObject:[context objectForKey:REQUEST_TYPE] forKey:REQUEST_TYPE];
        [context1 setObject:tasklistId forKey:@"TasklistId"];
        ASIFormDataRequest *postRequest = [request createPostRequest:url params:data headers:nil context:context1];
        if(postRequest == nil) {
            [delegate networkNotReachable];
            break;
        }
        [networkQueue addOperation:postRequest];
        [request release];
    }
    
    [networkQueue go];
}

- (void)getTasks:(NSString *)tasklistId
         context:(NSMutableDictionary *)context
        delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:TASK_GETBYPRIORITY_URL];
    NSLog(@"获取按优先级任务数据URL:%@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:tasklistId forKey:@"tasklistId"];
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}

- (void)syncTasks:(NSMutableArray*)tasklists
          context:(NSMutableDictionary*)context
            queue:(ASINetworkQueue*)networkQueue
         delegate:(id)delegate
{
    networkQueue.delegate = delegate;
    networkQueue.queueDidFinishSelector = @selector(queueFinished:);
    networkQueue.requestDidFinishSelector = @selector(requestFinished:);
    networkQueue.requestDidFailSelector = @selector(requestFailed:);
    
    NSMutableDictionary *queueContext = [NSMutableDictionary dictionary];
    [queueContext setObject:[context objectForKey:REQUEST_TYPE] forKey:REQUEST_TYPE];
    networkQueue.userInfo = queueContext;
    
    ChangeLogDao *changeLogDao = [[ChangeLogDao alloc] init];
    TaskIdxDao *taskIdxDao = [[TaskIdxDao alloc] init];
    
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:TASK_SYNC_URL];
    NSLog(@"syncTasklist服务路径: %@", url);
    for (Tasklist *tasklist in tasklists)
    {
        NSString *tasklistId = tasklist.id;
        if([tasklistId isEqualToString:@"github"]
        || [tasklistId isEqualToString:@"ifree"]
        || [tasklistId isEqualToString:@"wf"])
        {
            continue;
        }
        
        NSMutableArray *changeLogs = [changeLogDao getAllChangeLog:tasklistId];
        NSLog("改变记录总数: %d", changeLogs.count);
        
        //NSMutableArray *taskIdxs = [NSMutableArray array];
        
        //排序处理
        NSMutableArray *taskIdxs = [taskIdxDao getAllTaskIdx:tasklistId];
        
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
        
        HttpWebRequest *request = [[HttpWebRequest alloc] init];
        NSMutableDictionary *context1 = [NSMutableDictionary dictionary];
        [context1 setObject:[context objectForKey:REQUEST_TYPE] forKey:REQUEST_TYPE];
        [context1 setObject:tasklistId forKey:@"TasklistId"];
        ASIFormDataRequest *postRequest = [request createPostRequest:url params:data headers:nil context:context1];
        if(postRequest == nil) {
            [delegate networkNotReachable];
            break;
        }
        [networkQueue addOperation:postRequest];
        [request release];
    }
    
    [networkQueue go];
    
    [changeLogDao release];
    [taskIdxDao release];
}

@end
