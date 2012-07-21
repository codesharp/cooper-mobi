//
//  TaskService.h
//  Cooper
//
//  Created by sunleepy on 12-7-5.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "NetworkManager.h"

@class TaskDao;
@class TaskIdxDao;
@class ChangeLogDao;

@interface TaskService : NSObject

+ (void)testUrl:(id)delegate;

+ (void)getTasks:(id)delegate;

+ (void)syncTasks:(NSMutableArray*)changeLogs taskIdxs:(NSMutableArray*)taskIdxs delegate:(id)delegate;

+ (void)syncTask:(id)delegate;

@end
