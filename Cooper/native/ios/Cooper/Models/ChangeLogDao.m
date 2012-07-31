//
//  ChangeLogDao.m
//  Cooper
//
//  Created by sunleepy on 12-7-9.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "ChangeLogDao.h"
#import "ModelHelper.h"

@implementation ChangeLogDao

- (id)init
{
    if(self = [super init])
    {
        [super setContext];
    }
    return self;
}

- (NSMutableArray*) getAllChangeLog:(NSString*)tasklistId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChangeLog" inManagedObjectContext:context];
    
    NSError *error = nil;
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(tasklistId = %@)", tasklistId];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *changeLogs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"error: %@", [error description]);
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
    ChangeLog *changeLog = [ModelHelper create:@"ChangeLog" context:context];

    changeLog.changeType = type;
    changeLog.dataid = dataid;
    changeLog.name = name;
    changeLog.value = value;
    changeLog.isSend = [NSNumber numberWithInt:0];
    changeLog.tasklistId = tasklistId;
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
