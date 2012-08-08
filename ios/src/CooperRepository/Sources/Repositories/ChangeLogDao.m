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
                 dataid:(NSString *)dataid 
                   name:(NSString *)name 
                  value:(NSString *)value
             tasklistId:(NSString *)tasklistId
{
    ChangeLog *changeLog = [ModelHelper create:tableName context:context];

    changeLog.changeType = type;
    changeLog.dataid = dataid;
    changeLog.name = name;
    changeLog.value = value;
    changeLog.isSend = [NSNumber numberWithInt:0];
    changeLog.tasklistId = tasklistId;
    
    if([[ConstantClass instance] username].length > 0)
        changeLog.accountId = [[ConstantClass instance] username];
}

- (void)updateIsSend:(ChangeLog *)changeLog
{
    [changeLog setIsSend:[NSNumber numberWithInt:1]];
}

- (void)updateAllToSend:(NSString*)tasklistId
{
    NSMutableArray *changeLogs = [self getAllChangeLog:tasklistId];
    for(ChangeLog *changeLog in changeLogs)
    {
        //[self updateIsSend:changeLog];
        [self deleteChangLog:changeLog];
    }
}

- (void)deleteChangLog:(ChangeLog*)changeLog
{
    [context deleteObject:changeLog];
}

@end
