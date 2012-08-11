//
//  TasklistDao.h
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "RootDao.h"
#import "CooperCore/Tasklist.h"

@interface TasklistDao : RootDao
{
    NSString* tableName;
}
- (NSMutableArray*)getAllTasklist;

- (Tasklist*)getTasklistById:(NSString*)tasklistId;

- (NSMutableArray*)getAllTasklistByUserAndTemp;

- (NSMutableArray*)getAllTasklistByTemp;

- (NSMutableArray*)getAllTasklistByGuest;

- (void)updateTasklistIdByNewId:(NSString *)oldId
                          newId:(NSString *)newId;

- (void)deleteTasklist:(Tasklist*)tasklist;

- (void)deleteAll;

- (Tasklist*)addTasklist:(NSString*)id :(NSString*)name :(NSString*)type;

- (void)adjustId:(NSString *)oldId withNewId:(NSString *)newId;

- (void)updateEditable:(NSNumber*)editable tasklistId:(NSString*)tasklistId;

@end
