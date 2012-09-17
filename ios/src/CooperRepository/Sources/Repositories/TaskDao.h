//
//  TaskDao.h
//  Cooper
//
//  Created by sunleepy on 12-7-6.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "RootDao.h"
#import "CooperCore/Task.h"

@interface TaskDao : RootDao
{
    NSString* tableName;
}

//获取当天的任务
- (NSMutableArray*)getTaskByToday;
//通过指定的tasklistId获取所有的任务
- (NSMutableArray*)getAllTask:(NSString*)tasklistId;
//通过本地临时获取任务
- (NSMutableArray*)getAllTaskByTemp;
//通过指定的taskId获取任务
- (Task*)getTaskById:(NSString*)taskId;
//删除指定的任务
- (void)deleteTask:(Task*)task;
//通过指定的tasklistId删除所有的任务
- (void)deleteAll:(NSString*)tasklistId;
//保存任务
- (void)saveTask:(NSString*)taskId
         subject:(NSString*)subject
  lastUpdateDate:(NSDate*)lastUpdateDate
            body:(NSString *)body 
        isPublic:(NSNumber *)isPublic 
          status:(NSNumber *)status 
        priority:(NSString *)priority 
         dueDate:(NSDate *)dueDate
        editable:(NSNumber *)editable
      tasklistId:(NSString*)tasklistId;
//添加任务
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
//更新任务
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
//通过指定的tasklistId更新新的TaskId
- (void)updateTaskIdByNewId:(NSString*)oldId 
                      newId:(NSString*)newId 
                 tasklistId:(NSString*)tasklistId;
//更新新的TasklistId
- (void)updateTasklistIdByNewId:(NSString*)oldId
                          newId:(NSString*)newId;

@end
