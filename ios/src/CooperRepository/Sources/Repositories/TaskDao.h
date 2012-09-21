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

#pragma mark - 个人任务相关

//获取当天的任务
- (NSMutableArray*)getTaskByToday;
//通过指定的tasklistId获取所有的任务
- (NSMutableArray*)getAllTask:(NSString*)tasklistId;
//通过本地临时获取任务
- (NSMutableArray*)getAllTaskByTemp;
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
//更新新的TasklistId
- (void)updateTasklistIdByNewId:(NSString*)oldId
                          newId:(NSString*)newId;

#pragma mark - 团队任务相关

//添加团队任务
- (void)addTeamTask:(NSString*)subject
         createDate:(NSDate*)createDate
     lastUpdateDate:(NSDate*)lastUpdateDate
               body:(NSString*)body
           isPublic:(NSNumber*)isPublic
             status:(NSNumber*)status
           priority:(NSString*)priority
             taskId:(NSString*)tid
            dueDate:(NSDate*)dueDate
           editable:(NSNumber*)editable
     createMemberId:(NSString*)createMemberId
         assigneeId:(NSString*)assigneeId
           projects:(NSString*)projects
               tags:(NSString*)tags
             teamId:(NSString*)teamId;
//通过指定团队条件获取团队任务
- (NSMutableArray*)getTasksByTeam:(NSString*)teamId;
//更新团队任务
- (void)updateTaskByTeam:(Task*)task
                 subject:(NSString *)subject
          lastUpdateDate:(NSDate *)lastUpdateDate
                    body:(NSString *)body
                isPublic:(NSNumber *)isPublic
                  status:(NSNumber *)status
                priority:(NSString *)priority
                 dueDate:(NSDate *)dueDate
                assignee:(NSString*)assignee
                projects:(NSString*)projects
                    tags:(NSString*)tags
                  teamId:(NSString*)teamId
               projectId:(NSString*)projectId
                memberId:(NSString*)memberId
                     tag:(NSString*)tag;
//删除指定的TeamTask
- (void)deleteAllByTeam:(NSString*)teamId;

#pragma mark - 公共

//通过指定的taskId获取任务
- (Task*)getTaskById:(NSString*)taskId;
//通过指定的tasklistId更新新的TaskId
- (void)updateTaskIdByNewId:(NSString*)oldId
                      newId:(NSString*)newId;

@end
