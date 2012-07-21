//
//  ChangeLogDao.m
//  Cooper
//
//  Created by sunleepy on 12-7-9.
//  Copyright (c) 2012年 alibaba. All rights reserved.
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

- (NSMutableArray*) getAllChangeLog
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChangeLog" inManagedObjectContext:context];
    
    NSError *error = nil;
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isSend = 0)"];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *changeLogs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"error: %@", [error description]);
    }
    
    [fetchRequest release];
    
    return changeLogs;
}

- (void)insertChangeLog:(NSNumber *)type dataid:(NSString *)dataid name:(NSString *)name value:(NSString *)value
{
    ChangeLog *changeLog = [ModelHelper create:@"ChangeLog" context:context];

    [changeLog setChangeType:type];
    [changeLog setDataid:dataid];
    [changeLog setName:name];
    [changeLog setValue:value];
    [changeLog setIsSend:[NSNumber numberWithInt:0]];
}

- (void)updateIsSend:(ChangeLog *)changeLog
{
    [changeLog setIsSend:[NSNumber numberWithInt:1]];
}

- (void)updateAllToSend
{
    NSMutableArray *changeLogs = [self getAllChangeLog];
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
