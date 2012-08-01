//
//  TaskDao.h
//  Cooper
//
//  Created by sunleepy on 12-7-6.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "RootDao.h"
#import "Task.h"

@interface TaskDao : RootDao
{
    NSString* tableName;
}
- (NSMutableArray*)getTaskByToday;

- (NSMutableArray*)getAllTask:(NSString*)tasklistId;

- (Task*)getTaskById:(NSString*)taskId;

- (void)deleteTask:(Task*)task;

- (void)deleteAll:(NSString*)tasklistId;

- (void)addTask:(NSString*)subject 
     createDate:(NSDate*)createDate 
 lastUpdateDate:(NSDate*)lastUpdateDate 
           body:(NSString*)body 
       isPublic:(NSNumber*)isPublic 
         status:(NSNumber*)status 
       priority:(NSString*)priority 
         taskid:(NSString*)tid 
        dueDate:(NSDate*)dueDate 
       editable:(NSNumber*)editable
     tasklistId:(NSString*)tasklistId
       isCommit:(BOOL)isCommit;

- (void)updateTask:(Task*)task
           subject:(NSString*)subject 
    lastUpdateDate:(NSDate*)lastUpdateDate 
              body:(NSString*)body 
          isPublic:(NSNumber*)isPublic 
            status:(NSNumber*)status 
          priority:(NSString*)priority 
           dueDate:(NSDate*)dueDate 
        tasklistId:(NSString*)tasklistId
          isCommit:(BOOL)isCommit;

- (void)updateTaskIdByNewId:(NSString*)oldId 
                      newId:(NSString*)newId 
                 tasklistId:(NSString*)tasklistId;

@end
