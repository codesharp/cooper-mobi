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

//获取所有的任务列表
- (NSMutableArray*)getAllTasklist;
//通过指定的tasklistId获取任务列表
- (Tasklist*)getTasklistById:(NSString*)tasklistId;
//通过指定的User以及本地临时获取所有的任务列表
- (NSMutableArray*)getAllTasklistByUserAndTemp;
//通过本地临时获取所有的任务列表
- (NSMutableArray*)getAllTasklistByTemp;
//获取游客的所有任务列表
- (NSMutableArray*)getAllTasklistByGuest;
//修改新的TasklistId
- (void)updateTasklistIdByNewId:(NSString *)oldId
                          newId:(NSString *)newId;
//删除指定的任务列表
- (void)deleteTasklist:(Tasklist*)tasklist;
//删除所有
- (void)deleteAll;
//添加任务列表
- (Tasklist*)addTasklist:(NSString*)id :(NSString*)name :(NSString*)type;
//调整新的TasklistId
- (void)adjustId:(NSString *)oldId withNewId:(NSString *)newId;
//修改是否可编辑
- (void)updateEditable:(NSNumber*)editable tasklistId:(NSString*)tasklistId;

@end
