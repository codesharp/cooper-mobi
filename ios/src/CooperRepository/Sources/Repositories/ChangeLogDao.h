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
//更新改变记录状态
- (void)updateIsSend:(ChangeLog *)changeLog;
//删除指定的改变记录
- (void)deleteChangLog:(ChangeLog*)changeLog;
//更新新的TasklistId
- (void)updateTasklistIdByNewId:(NSString*)oldId newId:(NSString*)newId;

@end
