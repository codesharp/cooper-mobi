//
//  TaskService.h
//  Cooper
//
//  Created by sunleepy on 12-7-5.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@class TaskDao;
@class TaskIdxDao;
@class ChangeLogDao;

@interface TaskService : NSObject

+ (void)testUrl:(id)delegate;

+ (void)getTasks:(NSString*)tasklistId delegate:(id)delegate;

+ (void)syncTasks:(NSString*)tasklistId changeLogs:(NSMutableArray*)changeLogs taskIdxs:(NSMutableArray*)taskIdxs delegate:(id)delegate;

+ (void)syncTask:(NSString*)tasklistId delegate:(id)delegate;

@end
