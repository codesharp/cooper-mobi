//
//  TaskDao.h
//  Cooper
//
//  Created by sunleepy on 12-7-6.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import "RootDao.h"

@interface TaskDao : RootDao

- (NSMutableArray*)getAllTask;

- (Task*)getTaskById:(NSString*)taskId;

- (void)deleteTask:(Task*)task;

- (void)deleteAll;

- (void)addTask:(NSString*)subject 
     createDate:(NSData*)createDate 
 lastUpdateDate:(NSData*)lastUpdateDate 
           body:(NSString*)body 
       isPublic:(NSNumber*)isPublic 
         status:(NSNumber*)status 
       priority:(NSString*)priority 
         taskid:(NSString*)tid 
        dueDate:(NSDate*)dueDate 
       isCommit:(BOOL)isCommit;

- (void)updateTask:(Task*)task
           subject:(NSString*)subject 
    lastUpdateDate:(NSData*)lastUpdateDate 
              body:(NSString*)body 
          isPublic:(NSNumber*)isPublic 
            status:(NSNumber*)status 
          priority:(NSString*)priority 
           dueDate:(NSDate*)dueDate 
          isCommit:(BOOL)isCommit;

- (void)updateTaskIdByNewId:(NSString*)oldId newId:(NSString*)newId;

@end
