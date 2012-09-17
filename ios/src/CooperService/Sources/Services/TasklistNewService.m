//
//  TaslistNewService.m
//  CooperService
//
//  Created by sunleepy on 12-9-8.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TasklistNewService.h"
#import "CooperRepository/TasklistDao.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/TaskIdxDao.h"
#import "CooperRepository/ChangeLogDao.h"

@implementation TasklistNewService

- (void)getTasklists:(NSMutableDictionary*)context
delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:GETTASKLISTS_URL];
    NSLog(@"getTasklists服务路径: %@", url);
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:nil headers:nil context:context delegate:delegate];
    [request release];
}

- (void)syncTasklists:(NSMutableDictionary*)context
                queue:(ASINetworkQueue*)networkQueue
             delegate:(id)delegate
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
    
    if(tempTasklists.count == 0)
    {
        [delegate notProcessReturned:context];
        return;
    }
    
    networkQueue.delegate = delegate;
    networkQueue.queueDidFinishSelector = @selector(queueFinished:);
    networkQueue.requestDidFinishSelector = @selector(requestFinished:);
    networkQueue.requestDidFailSelector = @selector(requestFailed:);
    
    NSMutableDictionary *queueContext = [NSMutableDictionary dictionary];
    [queueContext setObject:[context objectForKey:REQUEST_TYPE] forKey:REQUEST_TYPE];
    networkQueue.userInfo = queueContext;

    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:CREATETASKLIST_URL];
    NSLog(@"syncTasklist服务路径: %@", url);
    for (Tasklist *tasklist in tempTasklists)
    {
        HttpWebRequest *request = [[HttpWebRequest alloc] init];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:tasklist.name forKey:@"name"];
        [params setObject:tasklist.listType forKey:@"type"];
        
        NSMutableDictionary *context1 = [NSMutableDictionary dictionary];
        [context1 setObject:@"CreateTasklist" forKey:REQUEST_TYPE];
        ASIFormDataRequest *postRequest = [request createPostRequest:url params:params headers:nil context:context];
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
    [taskDao release];
    [tasklistDao release];
}

- (void)syncTasklists:(NSString*)tasklistId context:(NSMutableDictionary *)context delegate:(id)delegate
{
    TasklistDao *tasklistDao = [[TasklistDao alloc] init];
    
    Tasklist *tasklist = [tasklistDao getTasklistById:tasklistId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:tasklist.name forKey:@"name"];
    [params setObject:tasklist.listType forKey:@"type"];
    
    [tasklistDao release];
    
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:CREATETASKLIST_URL];
    NSLog(@"同步%@的任务列表外部路径: %@", tasklistId, url);
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}

@end
