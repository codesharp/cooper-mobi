//
//  ChangeLogDao.h
//  Cooper
//
//  Created by sunleepy on 12-7-9.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CooperCore/ChangeLog.h"
#import "RootDao.h"

@interface ChangeLogDao : RootDao
{
    NSString* tableName;
}

#pragma mark - 个人任务相关

//获取本地临时的改变记录
- (NSMutableArray*)getAllChangeLogByTemp;
//通过指定的tasklistId获取改变记录
- (NSMutableArray*)getAllChangeLog:(NSString*)tasklistId;

//通过指定的tasklistId插入改变记录
- (void)insertChangeLog:(NSNumber*)type 
                 dataid:(NSString*)dataid 
                   name:(NSString*)name 
                  value:(NSString*)value 
             tasklistId:(NSString*)tasklistId;
//通过指定的
- (void)deleteChangeLogByTasklistId:(NSString*)tasklistId;
//删除指定的改变记录
- (void)deleteChangLog:(ChangeLog*)changeLog;
//更新新的TasklistId
- (void)updateTasklistIdByNewId:(NSString*)oldId newId:(NSString*)newId;
//更新新的TaskId 
- (void)updateTaskIdByNewId:(NSString*)oldId newId:(NSString*)newId;

#pragma mark - 团队任务相关

//获取团队的改变记录
- (NSMutableArray*)getChangeLogByTeam:(NSString*)teamId
                            projectId:(NSString*)projectId
                             memberId:(NSString*)memberId
                                  tag:(NSString*)tag;
//根据指定条件删除团队的改变记录
- (void)deleteChangeLogByTeam:(NSString*)teamId
                    projectId:(NSString*)projectId
                     memberId:(NSString*)memberId
                          tag:(NSString*)tag;

#pragma mark - 公共

//根据指定的TaskId获取改变记录
- (NSMutableArray*)getChangeLogByTaskId:(NSString*)taskId;
//更新新的TaskId
- (void)updateTaskIdByNewId:(NSString*)oldId newId:(NSString*)newId;

@end
