//
//  TaskIdxDao.h
//  Cooper
//
//  Created by sunleepy on 12-7-6.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//
#import "RootDao.h"
#import "CooperCore/TaskIdx.h"

@interface TaskIdxDao : RootDao
{
    NSString* tableName;
}

#pragma mark - 个人任务相关

//通过本地临时获取所有的任务索引
- (NSMutableArray*)getAllTaskIdxByTemp;
//通过指定的tasklistId获取所有的任务索引
- (NSMutableArray*)getAllTaskIdx:(NSString*)tasklistId;
//通过指定的key和tasklistId获取索引
- (TaskIdx*)getTaskIdxByKey:(NSString*)key 
                 tasklistId:(NSString*)tasklistId;
//更新索引
- (void)updateTaskIdx:(NSString*)taskId 
              byKey:(NSString*)key 
           tasklistId:(NSString*)tasklistId
           isCommit:(BOOL)isCommit;
//添加索引
- (void)addTaskIdx:(NSString*)tid 
             byKey:(NSString*)key 
        tasklistId:(NSString*)tasklistId
          isCommit:(BOOL)isCommit;
//添加索引
- (void)addTaskIdx:(NSString *)by 
               key:(NSString*)key 
              name:(NSString*)name 
           indexes:(NSString*)indexes 
        tasklistId:(NSString*)tasklistId;
//通过指定的tasklist
- (void)deleteTaskIndexsByTaskId:(NSString*)taskId 
                      tasklistId:(NSString*)tasklistId;
//通过指定的tasklistId
- (void)deleteAllTaskIdx:(NSString*)tasklistId;
//调整索引
- (void) adjustIndex:(NSString *)taskId 
       sourceTaskIdx:(TaskIdx *)sTaskIdx 
  destinationTaskIdx:(TaskIdx *)dTaskIdx 
      sourceIndexRow:(NSNumber*)sourceIndexRow 
        destIndexRow:(NSNumber*)destIndexRow
          tasklistId:(NSString*)tasklistId;
//保持索引
- (void)saveIndex:(TaskIdx*)taskIdx 
         newIndex:(NSMutableArray*)indexArray 
       tasklistId:(NSString*)tasklistId;
//通过指定的tasklistId修改新的的taskIdxId
- (void)updateTaskIdxByNewId:(NSString*)oldId 
                       newId:(NSString*)newId
                  tasklistId:(NSString*)tasklistId;
//修改新的TasklistId
- (void)updateTasklistIdByNewId:(NSString*)oldId 
                          newId:(NSString*)newId;

#pragma mark - 团队任务相关

//添加团队索引
- (void)addTaskIdxByTeam:(NSString *)tid
                   byKey:(NSString *)key
                  teamId:(NSString*)teamId
               projectId:(NSString*)projectId
                memberId:(NSString*)memberId
                     tag:(NSString*)tag;
//添加团队索引
- (void)addTeamTaskIdx:(NSString *)by
                   key:(NSString*)key
                  name:(NSString*)name
               indexes:(NSString*)indexes
                teamId:(NSString*)teamId
             projectId:(NSString*)projectId
              memberId:(NSString*)memberId
                   tag:(NSString*)tag;
//获取团队索引
- (NSMutableArray*)getAllTaskIdxByTeam:(NSString*)teamId
                             projectId:(NSString*)projectId
                              memberId:(NSString*)memberId
                                   tag:(NSString*)tag;
//更新索引
- (void)updateTaskIdxByNewIdAndTeam:(NSString*)oldId
                              newId:(NSString*)newId
                             teamId:(NSString*)teamId
                          projectId:(NSString*)projectId
                           memberId:(NSString*)memberId
                                tag:(NSString*)tag;
//删除指定的TaskIdx
- (void)deleteAllByTeam:(NSString*)teamId
              projectId:(NSString*)projectId
               memberId:(NSString*)memberId
                    tag:(NSString*)tag;
//删除指定的TaskIdx中的Indexs值
- (void)deleteTaskIndexsByTaskIdAndTeam:(NSString*)taskId
                                 teamId:(NSString*)teamId
                              projectId:(NSString*)projectId
                               memberId:(NSString*)memberId
                                    tag:(NSString*)tag;
//修改指定的TaskIdx
- (void)updateTaskIdxByTeam:(NSString *)taskId
                      byKey:(NSString *)key
                     teamId:(NSString*)teamId
                  projectId:(NSString*)projectId
                   memberId:(NSString*)memberId
                        tag:(NSString*)tag;
//调整索引
- (void) adjustIndexByTeam:(NSString *)taskId
             sourceTaskIdx:(TaskIdx *)sTaskIdx
        destinationTaskIdx:(TaskIdx *)dTaskIdx
            sourceIndexRow:(NSNumber*)sourceIndexRow
              destIndexRow:(NSNumber*)destIndexRow
                    teamId:(NSString*)teamId
                 projectId:(NSString*)projectId
                  memberId:(NSString*)memberId
                       tag:(NSString*)tag;

@end
