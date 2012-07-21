//
//  TaskIdxDao.h
//  Cooper
//
//  Created by sunleepy on 12-7-6.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "RootDao.h"

@interface TaskIdxDao : RootDao

- (NSMutableArray*)getAllTaskIdx;

- (TaskIdx*)getTaskIdxByKey:(NSString*)key;

- (void)updateTaskIdx:(NSString*)taskId 
              byKey:(NSString*)key 
           isCommit:(BOOL)isCommit;

- (void)addTaskIdx:(NSString*)tid 
             byKey:(NSString*)key 
          isCommit:(BOOL)isCommit;

- (void)addTaskIdx:(NSString *)by key:(NSString*)key name:(NSString*)name indexes:(NSString*)indexes;

- (void)deleteTaskIndexsByTaskId:(NSString*)taskId;

- (void)deleteAllTaskIdx;

- (void)adjustIndex:(NSString*)taskId sourceTaskIdx:(TaskIdx*)sTaskIdx destinationTaskIdx:(TaskIdx*) dTaskIdx indexSourceRow:(NSNumber*)sourceIndexRow destIndexRow:(NSNumber*)destIndexRow;

- (void)saveIndex:(TaskIdx*)taskIdx newIndex:(NSMutableArray*)indexArray;

- (void)updateTaskIdxByNewId:(NSString*)oldId newId:(NSString*)newId;

@end
