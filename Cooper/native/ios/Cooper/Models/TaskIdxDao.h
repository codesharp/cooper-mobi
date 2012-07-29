//
//  TaskIdxDao.h
//  Cooper
//
//  Created by sunleepy on 12-7-6.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//
#import "RootDao.h"
#import "TaskIdx.h"

@interface TaskIdxDao : RootDao

- (NSMutableArray*)getAllTaskIdx:(NSString*)tasklistId;

- (TaskIdx*)getTaskIdxByKey:(NSString*)key 
                 tasklistId:(NSString*)tasklistId;

- (void)updateTaskIdx:(NSString*)taskId 
              byKey:(NSString*)key 
           tasklistId:(NSString*)tasklistId
           isCommit:(BOOL)isCommit;

- (void)addTaskIdx:(NSString*)tid 
             byKey:(NSString*)key 
        tasklistId:(NSString*)tasklistId
          isCommit:(BOOL)isCommit;

- (void)addTaskIdx:(NSString *)by 
               key:(NSString*)key 
              name:(NSString*)name 
           indexes:(NSString*)indexes 
        tasklistId:(NSString*)tasklistId;

- (void)deleteTaskIndexsByTaskId:(NSString*)taskId 
                      tasklistId:(NSString*)tasklistId;

- (void)deleteAllTaskIdx:(NSString*)tasklistId;

- (void)adjustIndex:(NSString*)taskId 
      sourceTaskIdx:(TaskIdx*)sTaskIdx 
 destinationTaskIdx:(TaskIdx*) dTaskIdx 
     indexSourceRow:(NSNumber*)sourceIndexRow 
       destIndexRow:(NSNumber*)destIndexRow 
         tasklistId:(NSString*)tasklistId;

- (void)saveIndex:(TaskIdx*)taskIdx 
         newIndex:(NSMutableArray*)indexArray 
       tasklistId:(NSString*)tasklistId;

- (void)updateTaskIdxByNewId:(NSString*)oldId 
                       newId:(NSString*)newId
                  tasklistId:(NSString*)tasklistId;

@end
