//
//  TasklistDao.h
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "RootDao.h"
#import "Tasklist.h"

@interface TasklistDao : RootDao

- (NSMutableArray*)getAllTasklist;

- (void)deleteTasklist:(Tasklist*)tasklist;

- (void)deleteAll;

- (void)addTasklist:(NSString*)id :(NSString*)name :(NSString*)type;

- (void)adjustId:(NSString *)oldId withNewId:(NSString *)newId;

@end
