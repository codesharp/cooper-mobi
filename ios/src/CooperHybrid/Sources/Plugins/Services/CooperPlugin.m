//
//  CooperPlugin.m
//  CooperHybrid
//
//  Created by sunleepy on 12-8-9.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CooperPlugin.h"
#import "CooperService/AccountService.h"
#import "CooperService/TasklistService.h"
#import "CooperService/TaskService.h"
#import "CooperRepository/TasklistDao.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/TaskIdxDao.h"
#import "CooperRepository/ChangeLogDao.h"
#import "CodesharpSDK/NetworkManager.h"
#import "SBJsonParser.h"
#import "CooperPluginResult.h"

@implementation CooperPlugin

@synthesize tasklist_couter;
@synthesize tasklist_total;

#pragma mark - 与服务器交互方法

- (void)refresh:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString *callbackId = [arguments objectAtIndex:0];
    NSString *key = [options valueForKey:@"key"];
    NSMutableDictionary *resultCode = [NSMutableDictionary dictionary];
    
    //登录
    if([key isEqualToString: LOGIN])
    {
        NSString *username = [options valueForKey:@"username"];
        NSString *password = [options valueForKey:@"password"];
        NSString *type = [options valueForKey:@"type"];
        
        //type为空
        if(type.length == 0)
        {
            [resultCode setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
            [resultCode setObject:@"type不能为空!" forKey:@"message"];
        }
        else if(![type isEqualToString:ANONYMOUS] 
                && ![type isEqualToString:NORMAL])
        {
            [resultCode setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
            [resultCode setObject:@"type参数必须为anonymous或normal" forKey:@"message"];
        }

        if([type isEqualToString:ANONYMOUS]) //跳过登录
        {
            [[ConstantClass instance] setUsername:@""];
            [[ConstantClass instance] setLoginType:@"anonymous"];
            [ConstantClass saveToCache];
            
            [resultCode setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
        }
        else
        {          
            NSMutableDictionary *context = [NSMutableDictionary dictionary];
            [context setObject:LOGIN forKey:@"key"];
            [context setObject:username forKey:@"username"];
            [context setObject:callbackId forKey:@"callbackId"];
            //开始登录
            [AccountService login:username password:password context:context delegate:self];
            
            return;
        }
    }
    //注销
    else if ([key isEqualToString: LOGOUT]) { 
        
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        [context setObject:LOGOUT forKey:@"key"];
        [context setObject:callbackId forKey:@"callbackId"];
        //开始注销
        [AccountService logout:context delegate:self];
        
        return;
    }
    //同步任务列表
    else if ([key isEqualToString: SYNCTASKLISTS]) {
        
        if([[[ConstantClass instance] loginType] isEqualToString:@"anonymous"])
        {
            [resultCode setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
            [resultCode setObject:@"匿名用户不能同步任务" forKey:@"message"];
        }
        else {
            tasklist_couter = 0;
            tasklist_total = 0;
            
            //NSString *accountId = [options valueForKey:@"username"];
            
            NSMutableDictionary *context = [NSMutableDictionary dictionary];
            [context setObject:SYNCTASKLISTS forKey:@"key"];
            [context setObject:callbackId forKey:@"callbackId"];
            
            NSString *tasklistId = [options objectForKey:@"tasklistId"];
            //同步任务列表
            if(tasklistId == [NSNull null] || tasklistId.length == 0)
            {
                [TasklistService syncTasklists:context delegate:self];
            }
            //同步任务
            else {
                
                if([tasklistId rangeOfString:@"temp_"].length > 0)
                {
                    [context setObject:tasklistId forKey:@"tasklistId"];
                    [TasklistService syncTasklists:tasklistId context:context delegate:self];
                }
                else 
                {
                    NSMutableDictionary *context = [NSMutableDictionary dictionary];
                    [context setObject:SYNCTASKS forKey:@"key"];
                    [context setObject:tasklistId forKey:@"tasklistId"];
                    [context setObject:callbackId forKey:@"callbackId"];
                    
                    [TaskService syncTask:tasklistId context:context delegate:self];
                }
                
            }
            
            return;
        }
    }

    CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary:resultCode];    
    NSString *jsString = [result toSuccessCallbackString:callbackId];
    NSLog(@"%@ - Native返回的JS端数据: %@", key, jsString);
    [self writeJavascript:jsString];
}

#pragma mark - 本地取数据方法

- (void)get:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString *callbackId = [arguments objectAtIndex:0];
    NSString *key = [options valueForKey:@"key"];
    NSMutableDictionary *resultCode = [NSMutableDictionary dictionary];
    
    //查看网络在线情况
    if([key isEqualToString: GETNETWORKSTATUS]) {
        
        [resultCode setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
        [resultCode setObject:[NSNumber numberWithBool:[NetworkManager isOnline]] forKey:@"data"];
    }
    //获取当前用户
    else if([key isEqualToString: GETCURRENTUSER]) {
        
        [resultCode setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
          
        NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
        
        if([[ConstantClass instance] username].length > 0)
        {
            [userDict setObject:[[ConstantClass instance] username] forKey:@"username"];
        }
        else 
        {
            [userDict setObject:@"" forKey:@"username"];
        }
        [resultCode setObject:userDict forKey:@"data"];
    }
    //获取任务列表
    else if([key isEqualToString: GETTASKLISTS])
    {
        TasklistDao *tasklistDao = [[TasklistDao alloc] init];
        
        NSMutableArray *tasklists = [tasklistDao getAllTasklist];
        
        BOOL isDefaultTasklistExist = NO;
        for(Tasklist* tasklist in tasklists)
        {
            if([tasklist.id isEqualToString:@"0"])
            {
                isDefaultTasklistExist = YES;
                break;
            }
        }
        
        if(!isDefaultTasklistExist)
        {
            Tasklist *defaultTasklist = [tasklistDao addTasklist:@"0" : @"默认列表" : @"personal"];
            [tasklists addObject:defaultTasklist];
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (Tasklist *tasklist in tasklists)
        {
            [dict setObject:tasklist.name forKey:tasklist.id];
        }
        
        [tasklistDao release];
        
        [resultCode setObject:dict forKey:@"data"];
        [resultCode setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
    }
    //获取按优先级的任务
    else if([key isEqualToString: GETTASKSBYPRIORITY]) 
    {
        //TODO:返回一个值
        NSString *tasklistId = [options objectForKey:@"tasklistId"];
        
        TasklistDao *tasklistDao = [[TasklistDao alloc] init];
        TaskIdxDao *taskIdxDao = [[TaskIdxDao alloc] init];
        TaskDao *taskDao = [[TaskDao alloc] init];
        
        Tasklist *tasklist = [tasklistDao getTasklistById:tasklistId];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setObject:tasklist.editable forKey:@"editable"];
        
        NSMutableArray *taskIdxs = [taskIdxDao getAllTaskIdx:tasklistId];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableArray *task_array = [NSMutableArray array];
        NSMutableArray *taskIdx_array = [NSMutableArray array];
        
        //任务排序
        for(TaskIdx *taskIdx in taskIdxs)
        {
            NSMutableArray *taskIdsDict = [parser objectWithString:taskIdx.indexes];
            
            for(NSString *taskId in taskIdsDict)
            { 
                Task *task = [taskDao getTaskById:taskId];
                if(task.id.length > 0)
                {
                    NSMutableDictionary *taskDict = [NSMutableDictionary dictionary];
                    [taskDict setObject:task.id forKey:@"id"];
                    [taskDict setObject:task.subject forKey:@"subject"];
                    [taskDict setObject:task.body forKey:@"body"];
                    [taskDict setObject:task.status == [NSNumber numberWithInt:1] ? @"true" : @"false" forKey:@"isCompleted"];
                    [taskDict setObject:task.dueDate == nil ? @"" : [Tools ShortNSDateToNSString:task.dueDate] forKey:@"dueTime"];
                    [taskDict setObject:task.priority forKey:@"priority"];
                    
                    [task_array addObject:taskDict];
                }
            }
            
            NSMutableDictionary *taskIdx_dict = [NSMutableDictionary dictionary];
            [taskIdx_dict setObject:@"priority" forKey:@"by"];
            [taskIdx_dict setObject:taskIdx.key forKey:@"key"];
            [taskIdx_dict setObject:taskIdx.name forKey:@"name"];
            [taskIdx_dict setObject:taskIdsDict forKey:@"indexs"];
        
            [taskIdx_array addObject:taskIdx_dict];
        }
        
        [dict setObject:task_array forKey:@"tasks"];

        [dict setObject:taskIdx_array forKey:@"sorts"];
        
        [parser release];
        
        [taskDao release];
        [taskIdxDao release];
        [tasklistDao release];
        
        [resultCode setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
        [resultCode setObject:dict forKey:@"data"];
    }
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary:resultCode];    
    NSString *jsString = [result toSuccessCallbackString:callbackId];
    NSLog(@"%@ - Native返回的JS端数据: %@", key, jsString);
    [self writeJavascript:jsString];  
}

#pragma mark - 本地存数据方法

- (void)save:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSString *callbackId = [arguments objectAtIndex:0];
    NSString *key = [options valueForKey:@"key"];
    NSMutableDictionary *resultCode = [NSMutableDictionary dictionary];
    
    //创建本地任务列表
    if([key isEqualToString: CREATETASKLIST]) {
        NSString *tasklistId = [options valueForKey:@"id"];
        NSString *tasklistname = [options valueForKey:@"name"];
        NSString *tasklisttype = [options valueForKey:@"type"];
        
        TasklistDao *tasklistDao = [[TasklistDao alloc] init];
        
        [tasklistDao addTasklist:tasklistId :tasklistname :tasklisttype];
        
        [tasklistDao commitData];
        
        [tasklistDao release];
        
        [resultCode setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
    }
    //创建本地任务
    else if([key isEqualToString: CREATETASK]) {
        
        NSMutableDictionary *taskDict = [options objectForKey:@"task"];
        NSMutableArray *changesArray = [options objectForKey:@"changes"];
        NSString *tasklistId = [options objectForKey:@"tasklistId"];
        
        TaskDao *taskDao = [[TaskDao alloc] init];
        TaskIdxDao *taskIdxDao = [[TaskIdxDao alloc] init];
        ChangeLogDao *changeLogDao = [[ChangeLogDao alloc] init];
        
        NSDate *currentDate = [NSDate date];
        
        NSString *subject = [taskDict objectForKey:@"subject"];
        NSString *body = [taskDict objectForKey:@"body"];
        NSString *isCompleted = [taskDict objectForKey:@"isCompleted"];
        NSString *priority = [taskDict objectForKey:@"priority"];
        NSString *id = [taskDict objectForKey:@"id"];
        NSString *dueTime = [taskDict objectForKey:@"dueTime"];
        NSDate *dueTimeDate = [Tools NSStringToShortNSDate:dueTime];
        
        [taskDao saveTask:id
                  subject:subject
           lastUpdateDate:currentDate
                     body:body 
                 isPublic:[Tools BOOLToNSNumber:YES] 
                   status:[isCompleted isEqualToString:@"true"] ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0] 
                 priority:priority
                  dueDate:dueTimeDate 
                 editable:[NSNumber numberWithInt:1]
               tasklistId:tasklistId];
        
        [taskIdxDao addTaskIdx:id 
                         byKey:priority
                    tasklistId:tasklistId 
                      isCommit:NO];
        
        for(NSMutableDictionary *d in changesArray)
        {
            NSString *name = [d objectForKey:@"Name"];
            NSString *value = [d objectForKey:@"Value"];
            NSString *taskId = [d objectForKey:@"ID"];
            NSString *type = [d objectForKey:@"Type"];
            
            [changeLogDao insertChangeLog:[NSNumber numberWithInt:[type intValue]] 
                                   dataid:taskId 
                                     name:name 
                                    value:value 
                               tasklistId:tasklistId];
        }
        
        [taskDao commitData];
        
        [changeLogDao release];
        [taskIdxDao release];
        [taskDao release];
        
        [resultCode setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
    }
    //更新本地任务
    else if([key isEqualToString: UPDATETASK]) {
        NSMutableDictionary *taskDict = [options objectForKey:@"task"];
        NSMutableArray *changesArray = [options objectForKey:@"changes"];
        NSString *tasklistId = [options objectForKey:@"tasklistId"];
        
        TaskDao *taskDao = [[TaskDao alloc] init];
        TaskIdxDao *taskIdxDao = [[TaskIdxDao alloc] init];
        ChangeLogDao *changeLogDao = [[ChangeLogDao alloc] init];
        
        NSDate *currentDate = [NSDate date];
        
        NSString *subject = [taskDict objectForKey:@"subject"];
        NSString *body = [taskDict objectForKey:@"body"];
        NSString *isCompleted = [taskDict objectForKey:@"isCompleted"];
        NSString *priority = [taskDict objectForKey:@"priority"];
        NSString *id = [taskDict objectForKey:@"id"];
        NSString *dueTime = [taskDict objectForKey:@"dueTime"];      
        NSDate *dueTimeDate = [Tools NSStringToShortNSDate:dueTime];
        
        Task *task = [taskDao getTaskById:id];
        NSString* oldPriority = priority;
        if(task.id.length > 0)
        {
            oldPriority = task.priority;
        }
        
        [taskDao saveTask:id
                  subject:subject
           lastUpdateDate:currentDate
                     body:body 
                 isPublic:[Tools BOOLToNSNumber:YES] 
                   status:[isCompleted isEqualToString:@"true"] ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0]
                 priority:priority
                  dueDate:dueTimeDate 
                 editable:[NSNumber numberWithInt:1]
               tasklistId:tasklistId];
        
        if(![oldPriority isEqualToString:priority])
        {
            [taskIdxDao updateTaskIdx:id
                                byKey:priority 
                           tasklistId:tasklistId
                             isCommit:NO];
        }
        
        for(NSMutableDictionary *d in changesArray)
        {
            NSString *name = [d objectForKey:@"Name"];
            NSString *value = [d objectForKey:@"Value"];
            NSString *taskId = [d objectForKey:@"ID"];
            NSString *type = [d objectForKey:@"Type"];
              
            [changeLogDao insertChangeLog:[NSNumber numberWithInt:[type intValue]] 
                                   dataid:taskId 
                                     name:name 
                                    value:value 
                               tasklistId:tasklistId];
        }
        
        [taskDao commitData];
        
        [changeLogDao release];
        [taskIdxDao release];
        [taskDao release];
        
        [resultCode setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
    }
    //删除本地任务
    else if([key isEqualToString: DELETETASK]) {
        
        NSString *tasklistId = [options objectForKey:@"tasklistId"];
        NSString *taskId = [options objectForKey:@"taskId"];
        
        TaskDao *taskDao = [[TaskDao alloc] init];
        TaskIdxDao *taskIdxDao = [[TaskIdxDao alloc] init];
        ChangeLogDao *changeLogDao = [[ChangeLogDao alloc] init];
        
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:1] 
                               dataid:taskId
                                 name:@"" 
                                value:@""
                           tasklistId:tasklistId];   
        
        [taskIdxDao deleteTaskIndexsByTaskId:taskId
                                  tasklistId:tasklistId];    
        
        Task *task = [taskDao getTaskById:taskId];
        [taskDao deleteTask:task];
        
        [taskDao commitData];
        
        [changeLogDao release];
        [taskIdxDao release];
        [taskDao release];
        
        [resultCode setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
    }
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary:resultCode];    
    NSString *jsString = [result toSuccessCallbackString:callbackId];
    NSLog(@"%@ - Native返回的JS端数据: %@", key, jsString);
    [self writeJavascript:jsString];    
}

#pragma mark - Debug Log

- (void)debug:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    NSLog(@"JS端日志: \r\n -------------- %@", options);
}

#pragma mark - 回调相关

- (void)addRequstToPool:(ASIHTTPRequest *)request {
    NSLog(@"发送请求：%@",request.url);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"请求响应数据: %@, %d", [request responseString], [request responseStatusCode]);
    
    NSString *jsString = nil;
    NSMutableDictionary *resultCode = [NSMutableDictionary dictionary];
    
    NSString *key = [request.userInfo objectForKey:@"key"];
    
    //登录回调
    if([key isEqualToString:LOGIN])
    {
        if(request.responseStatusCode == 200)
        {
            NSString *responseString = [request responseString];
            
            NSArray* array = [request responseCookies];
            NSLog(@"存储Cookies数组个数: %d",  array.count);
            
            NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:array];
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dict];
            NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            
            [sharedHTTPCookie setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            [sharedHTTPCookie setCookie:cookie];
            
            NSString *username = [request.userInfo objectForKey:@"username"];
            
            //保存用户账号
            [[ConstantClass instance] setUsername:username];
            [[ConstantClass instance] setLoginType:@"normal"];
            [ConstantClass saveToCache];
            
            [resultCode setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
            [resultCode setObject:[NSNumber numberWithBool:[responseString boolValue]] forKey:@"data"];
        }
        else //TODO:statusCode:400
        {
            [resultCode setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
            [resultCode setObject:[NSString stringWithFormat:@"错误状态码:%d,错误消息: %@", [request responseStatusCode], [request responseStatusMessage]] forKey:@"message"];
        }
    }
    //注销回调
    else if([key isEqualToString:LOGOUT])
    {
        if(request.responseStatusCode == 200)
        {
            [resultCode setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
        }
        else 
        {
            [resultCode setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
            [resultCode setObject:[NSString stringWithFormat:@"错误状态码:%d,错误消息: %@", [request responseStatusCode], [request responseStatusMessage]] forKey:@"message"];
        }
    }
    //同步任务列表回调
    else if([key isEqualToString:SYNCTASKLISTS])
    {
        if(request.responseStatusCode == 200)
        {
            NSMutableArray *responseArray = [request.responseString JSONValue];
            
            TasklistDao *tasklistDao = [[TasklistDao alloc] init];
            TaskDao *taskDao = [[TaskDao alloc] init];
            TaskIdxDao *taskIdxDao = [[TaskIdxDao alloc] init];
            ChangeLogDao *changLogDao = [[ChangeLogDao alloc] init];
            
            NSString *newTasklistId = nil;
            for (NSMutableDictionary *dict in responseArray) {
                NSString *oldId = [dict objectForKey:@"OldId"];
                NSString *newId = [dict objectForKey:@"NewId"];
                
                NSLog(@"任务旧值ID: %@ 变为新值ID:%@", oldId, newId);

                [tasklistDao updateTasklistIdByNewId:oldId newId:newId];        
                
                if([[ConstantClass instance] username].length > 0)
                {
                    //刷新其他表
                    [taskDao updateTasklistIdByNewId:oldId newId:newId];
                    
                    [taskIdxDao updateTasklistIdByNewId:oldId newId:newId];
                    
                    [changLogDao updateTasklistIdByNewId:oldId newId:newId];
                    
                    newTasklistId = newId;
                }
                
            }  
            [tasklistDao commitData];
            
            [changLogDao release];
            [taskIdxDao release];
            [taskDao release];
            [tasklistDao release];
            
            NSString *callbackId = [request.userInfo objectForKey:@"callbackId"];
            
            NSMutableDictionary *context = [NSMutableDictionary dictionary];
            [context setObject:callbackId forKey:@"callbackId"];
            
            NSString *tasklistId = [request.userInfo objectForKey:@"tasklistId"];
            
            if(tasklistId == [NSNull null] || tasklistId.length == 0)
            {
                [context setObject:GETTASKLISTS_SERVER forKey:@"key"];
                [TasklistService getTasklists:context delegate:self];
            }
            else
            {
                [context setObject:SYNCTASKS forKey:@"key"];
                [context setObject:newTasklistId forKey:@"tasklistId"];
                
                [TaskService syncTask:newTasklistId context:context delegate:self];
            }
            
            return;
        }
        else 
        {
            [resultCode setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
            [resultCode setObject:[NSString stringWithFormat:@"错误状态码:%d,错误消息: %@", [request responseStatusCode], [request responseStatusMessage]] forKey:@"message"];
        }
    }
    else if([key isEqualToString:GETTASKLISTS_SERVER])
    {
        if(request.responseStatusCode == 200)
        {
            TasklistDao *tasklistDao = [[TasklistDao alloc] init];
            NSMutableDictionary *tasklistsDict = [[request responseString] JSONValue];
        
            //删除当前账户所有任务列表
            [tasklistDao deleteAll];
            
            for(NSString* key in tasklistsDict.allKeys)
            {
                NSString *value = [tasklistsDict objectForKey:key];
                
                [tasklistDao addTasklist:key:value:@"personal"];
            }
            
            //加上默认列表
            [tasklistDao addTasklist:@"0" :@"默认列表" :@"personal"];
            
            [tasklistDao commitData];
            
            NSMutableArray *tasklists = [tasklistDao getAllTasklist];
            
            [tasklistDao release];
            
            if(tasklists.count == 0)
            {
                [resultCode setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
            }
            else 
            {
                NSString* callbackId = [request.userInfo objectForKey:@"callbackId"];
                tasklist_couter = 0;    
                tasklist_total = tasklists.count;
                for (Tasklist *tasklist in tasklists) 
                {
                    NSMutableDictionary *context = [NSMutableDictionary dictionary];
                    [context setObject:callbackId forKey:@"callbackId"];
                    [context setObject:SYNCTASKS forKey:@"key"];
                    [context setObject:tasklist.id forKey:@"tasklistId"];
                    
                    [TaskService syncTask:tasklist.id context:context delegate:self];
                }
                return;
            }  
        }
        else 
        {
            [resultCode setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
            [resultCode setObject:[NSString stringWithFormat:@"错误状态码:%d,错误消息: %@", [request responseStatusCode], [request responseStatusMessage]] forKey:@"message"];
        }
    }
    //同步任务回调
    else if([key isEqualToString:SYNCTASKS])
    {
        if([request responseStatusCode] == 200)
        {
            NSString *responseString = request.responseString;
            NSMutableArray *array = [responseString JSONValue];
            
            NSString *tasklistId = [request.userInfo objectForKey:@"tasklistId"];
            
            TaskDao *taskDao = [[TaskDao alloc] init];
            TaskIdxDao *taskIdxDao = [[TaskIdxDao alloc] init];
            ChangeLogDao *changeLogDao = [[ChangeLogDao alloc] init]; 
            
            if(array.count > 0)
            {
                for(NSMutableDictionary *dict in array)
                {
                    NSString * oldId = (NSString*)[dict objectForKey:@"OldId"];
                    NSString * newId = (NSString*)[dict objectForKey:@"NewId"];
                    
                    NSLog(@"任务旧值ID: %@ 变为新值ID:%@", oldId, newId);
                 
                    [taskDao updateTaskIdByNewId:oldId newId:newId tasklistId:tasklistId];
                    [taskIdxDao updateTaskIdxByNewId:oldId newId:newId tasklistId:tasklistId];    
                }
            }
            
            //修正changeLog
            [changeLogDao updateAllToSend:tasklistId];
            [changeLogDao commitData];
            
            [changeLogDao release];
            [taskIdxDao release];
            [taskDao release]; 
            
            NSString *callbackId = [request.userInfo objectForKey:@"callbackId"];
            NSMutableDictionary *context = [NSMutableDictionary dictionary];
            [context setObject:GETTASKSBYPRIORITY_SERVER forKey:@"key"];
            [context setObject:tasklistId forKey:@"tasklistId"];
            [context setObject:callbackId forKey:@"callbackId"];
            
            //获取Tasks更新本地数据
            [TaskService getTasks:tasklistId context:context delegate:self];
            
            return;
        }
        else
        {
            [resultCode setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
            [resultCode setObject:[NSString stringWithFormat:@"错误状态码:%d,错误消息: %@", [request responseStatusCode], [request responseStatusMessage]] forKey:@"message"];
        }
    }
    //获取按优先级回调
    else if([key isEqualToString:GETTASKSBYPRIORITY_SERVER])
    {
        if([request responseStatusCode] == 200)
        {
            TaskDao *taskDao = [[TaskDao alloc] init];
            TaskIdxDao *taskIdxDao = [[TaskIdxDao alloc] init];
            TasklistDao *tasklistDao = [[TasklistDao alloc] init];
            
            NSString *tasklistId = [request.userInfo objectForKey:@"tasklistId"];
            
            NSMutableDictionary *dict = [[request responseString] JSONValue];
            
            NSString *tasklist_editable = [dict objectForKey:@"Editable"];
            
            //更新Tasklist的可编辑状态
            [tasklistDao updateEditable:[NSNumber numberWithInt:[tasklist_editable integerValue]] tasklistId:tasklistId];
            
            NSArray *tasks = [dict objectForKey:@"List"]; 
            NSArray *taskIdxs =[dict objectForKey:@"Sorts"];
            
            [taskDao deleteAll:tasklistId];
            [taskIdxDao deleteAllTaskIdx:tasklistId];
            
            //执行
            [taskIdxDao commitData];
            
            for(NSDictionary *taskDict in tasks)
            {
                NSString *taskId = [NSString stringWithFormat:@"%@", (NSString*)[taskDict objectForKey:@"ID"]];  
                
                NSString* subject = [taskDict objectForKey:@"Subject"] == [NSNull null] ? @"" : [taskDict objectForKey:@"Subject"];
                NSString *body = [taskDict objectForKey:@"Body"] == [NSNull null] ? @"" : [taskDict objectForKey:@"Body"];
                NSString *isCompleted = (NSString*)[taskDict objectForKey:@"IsCompleted"];
                NSNumber *status = [NSNumber numberWithInt:[isCompleted integerValue]];    
                NSString *priority = [NSString stringWithFormat:@"%@", [taskDict objectForKey:@"Priority"]];
                
                NSString *editable = (NSString*)[taskDict objectForKey:@"Editable"];
                
                
                NSDate *due = nil;
                if([taskDict objectForKey:@"DueTime"] != [NSNull null])
                    due = [Tools NSStringToShortNSDate:[taskDict objectForKey:@"DueTime"]];
                
                [taskDao addTask:subject 
                      createDate:[NSDate date] 
                  lastUpdateDate:[NSDate date] 
                            body:body 
                        isPublic:[NSNumber numberWithInt:1] 
                          status:status
                        priority:priority 
                          taskid:taskId 
                         dueDate:due
                        editable:[NSNumber numberWithInt:[editable integerValue]]
                      tasklistId:tasklistId
                        isCommit:NO];
            }
            
            for(NSDictionary *idxDict in taskIdxs)
            {            
                NSString *by = (NSString*)[idxDict objectForKey:@"By"];
                NSString *key = (NSString*)[idxDict objectForKey:@"Key"];
                NSString *name = (NSString*)[idxDict objectForKey:@"Name"];  
                
                NSArray *array = (NSArray*)[idxDict objectForKey:@"Indexs"];
                NSString *indexes = [array JSONRepresentation];
                
                [taskIdxDao addTaskIdx:by key:key name:name indexes:indexes tasklistId:tasklistId];
            }
            
            [taskIdxDao commitData];
            
            //TODO:如果个数小于总数直接返回，继续操作
            tasklist_couter++;
            if(tasklist_couter < tasklist_total)
                return;
            
            [resultCode setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
        }
        else
        {
            [resultCode setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
            [resultCode setObject:[NSString stringWithFormat:@"错误状态码:%d,错误消息: %@", [request responseStatusCode], [request responseStatusMessage]] forKey:@"message"];
        }
    }
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary:resultCode];
    NSString *callbackId = [request.userInfo objectForKey:@"callbackId"];
    jsString = [result toSuccessCallbackString:callbackId];
    NSLog(@"回调 %@ - Native返回的JS端数据: %@", key, jsString);
    [request.delegate writeJavascript:jsString];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求异常: %@", request.error);
    NSMutableDictionary *resultCode = [NSMutableDictionary dictionary];
    
    [resultCode setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
    [resultCode setObject:request.error forKey:@"message"];
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultCode];
    NSString *callbackId = [request.userInfo objectForKey:@"callbackId"];
    NSString *jsString = [result toSuccessCallbackString:callbackId];
    NSLog(@"Native返回的JS端错误数据: %@", jsString);
    [request.delegate writeJavascript:jsString];
}

@end
