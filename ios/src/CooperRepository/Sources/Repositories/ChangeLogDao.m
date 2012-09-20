//
//  ChangeLogDao.m
//  Cooper
//
//  Created by sunleepy on 12-7-9.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "ChangeLogDao.h"
#import "CooperCore/ModelHelper.h"

@implementation ChangeLogDao

- (id)init
{
    if(self = [super init])
    {
        [super setContext];
        tableName = @"ChangeLog";
    }
    return self;
}

#pragma mark - 个人任务相关

- (NSMutableArray*)getAllChangeLogByTemp
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(accountId = nil and teamId = nil)"];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil; 
    
    [fetchRequest setEntity:entity];
    NSMutableArray *changeLogs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    [fetchRequest release];
    
    return [changeLogs autorelease];
}
- (NSMutableArray*) getAllChangeLog:(NSString*)tasklistId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    NSError *error = nil;
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    if([[ConstantClass instance] username].length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"(tasklistId = %@ and accountId = %@)", tasklistId, [[ConstantClass instance] username]];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"(tasklistId = %@ and accountId = nil)", tasklistId];
    }
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *changeLogs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"数据库错误异常: %@", [error description]);
    }
    
    [fetchRequest release];
    
    return changeLogs;
}
- (void)insertChangeLog:(NSNumber *)type 
                 dataid:(NSString *)dataId 
                   name:(NSString *)name 
                  value:(NSString *)value
             tasklistId:(NSString *)tasklistId
{
    ChangeLog *changeLog = [ModelHelper create:tableName context:context];

    changeLog.changeType = type;
    changeLog.dataId = dataId;
    changeLog.name = name;
    changeLog.value = value;
    changeLog.tasklistId = tasklistId;
    
    if([[ConstantClass instance] username].length > 0)
        changeLog.accountId = [[ConstantClass instance] username];
}
- (void)deleteChangeLogByTasklistId:(NSString*)tasklistId
{
    NSMutableArray *changeLogs = [self getAllChangeLog:tasklistId];
    for(ChangeLog *changeLog in changeLogs)
    {
        [self deleteChangLog:changeLog];
    }
}
- (void)deleteChangLog:(ChangeLog*)changeLog
{
    [context deleteObject:changeLog];
}
- (void)updateTasklistIdByNewId:(NSString*)oldId newId:(NSString*)newId
{
    NSMutableArray *changeLogs = [self getAllChangeLog:oldId];
    for (ChangeLog *changeLog in changeLogs) {
        changeLog.tasklistId = newId;
    }
}

#pragma mark - 团队任务相关

- (NSMutableArray*)getChangeLogByTeam:(NSString *)teamId
                            projectId:(NSString *)projectId
                             memberId:(NSString *)memberId
                                  tag:(NSString *)tag
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(teamId = %@ and projectId = %@ and memberId = %@ and tag = %@)"
//                              , teamId
//                              , projectId
//                              , memberId
//                              , tag];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(teamId = %@)", teamId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *changeLogs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"数据库错误异常: %@", [error description]);
    }
    
    [fetchRequest release];
    
    return changeLogs;
}
- (void)deleteChangeLogByTeam:(NSString*)teamId
                    projectId:(NSString*)projectId
                     memberId:(NSString*)memberId
                          tag:(NSString*)tag
{
    NSMutableArray *changeLogs = [self getChangeLogByTeam:teamId
                                                projectId:projectId
                                                 memberId:memberId
                                                      tag:tag];
    for(ChangeLog *changeLog in changeLogs)
    {
        [self deleteChangLog:changeLog];
    }
}
- (void)insertChangeLogByTeam:(NSNumber*)type
                       dataId:(NSString*)dataId
                         name:(NSString*)name
                        value:(NSString*)value
                       teamId:(NSString*)teamId
                    projectId:(NSString*)projectId
                     memberId:(NSString*)memberId
                          tag:(NSString*)tag
{
    ChangeLog *changeLog = [ModelHelper create:tableName context:context];
    
    changeLog.changeType = type;
    changeLog.dataId = dataId;
    changeLog.name = name;
    changeLog.value = value;
    changeLog.teamId = teamId;
    changeLog.projectId = projectId;
    changeLog.memberId = memberId;
    changeLog.tag = tag;
}

#pragma mark - 公共

- (NSMutableArray*)getChangeLogByTaskId:(NSString*)taskId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    NSError *error = nil;
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(dataId = %@)", taskId];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *changeLogs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"数据库错误异常: %@", [error description]);
    }
    
    [fetchRequest release];
    
    return changeLogs;
}
- (void)updateTaskIdByNewId:(NSString*)oldId newId:(NSString*)newId
{
    NSMutableArray *changeLogs = [self getChangeLogByTaskId:oldId];
    
    for (ChangeLog *changeLog in changeLogs)
    {
        [self deleteChangLog:changeLog];
    }
}

@end
