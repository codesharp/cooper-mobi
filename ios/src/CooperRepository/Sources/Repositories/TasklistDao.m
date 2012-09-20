//
//  TasklistDao.m
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TasklistDao.h"
#import "CooperCore/ModelHelper.h"
#import "CooperCore/Tasklist.h"


@implementation TasklistDao

- (id)init
{
    if(self = [super init])
    {
        [super setContext];
        tableName = @"Tasklist";
    }
    return self;
}

- (NSMutableArray*)getAllTasklist
{    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName 
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
//    NSSortDescriptor *sortDescriptor =  [[NSSortDescriptor alloc] initWithKey:@"id" 
//                                                                    ascending:YES];
//    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate;
    if([[ConstantClass instance] username].length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"(accountId = %@)"
                                  , [[ConstantClass instance] username]];
    }
    else 
    {
        predicate = [NSPredicate predicateWithFormat:@"(accountId = nil)"];
    }
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil; 
   
    NSMutableArray *tasklists = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    [fetchRequest release];
    
    return [tasklists autorelease];
}
- (Tasklist*)getTasklistById:(NSString *)tasklistId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context]; 
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    if([[ConstantClass instance] username].length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"(id = %@ and accountId = %@)"
                     , tasklistId, [[ConstantClass instance] username]];
    }
    else 
    {
        predicate = [NSPredicate predicateWithFormat:@"(id = %@ and accountId = nil)", tasklistId];
    }
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil; 
    
    NSMutableArray *tasklists = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    Tasklist *tasklist;
    if(tasklists.count > 0)
    {
        tasklist = [tasklists objectAtIndex:0];
    }
    
    [fetchRequest release];
    
    return [tasklist autorelease];
}
- (NSMutableArray*)getAllTasklistByUserAndTemp
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName 
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor =  [[NSSortDescriptor alloc] initWithKey:@"id" 
                                                                    ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate;
    if([[ConstantClass instance] username].length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"(id like[c] %@ and accountId = %@)"
                     , @"temp_*"
                     , [[ConstantClass instance] username]];
    }
    else 
    {
        predicate = [NSPredicate predicateWithFormat:@"(id like[c] %@ and accountId = nil)", @"temp_*"];
    }
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %@)", tasklistId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil; 
    
    NSMutableArray *tasklists = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    [fetchRequest release];
    
    return [tasklists autorelease];
}
- (NSMutableArray*)getAllTasklistByTemp
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName                                     inManagedObjectContext:context];

    
    NSSortDescriptor *sortDescriptor =  [[NSSortDescriptor alloc] initWithKey:@"id" 
                                                                    ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id like[c] %@ and accountId = nil)", @"temp_*"];

    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil; 
    
    [fetchRequest setEntity:entity];
    NSMutableArray *tasklists = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    [fetchRequest release];
    
    return [tasklists autorelease];
}
- (NSMutableArray*)getAllTasklistByGuest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName 
                                              inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor =  [[NSSortDescriptor alloc] initWithKey:@"id" 
                                                                    ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(accountId = nil)"];

    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil; 
    [fetchRequest setEntity:entity];
    NSMutableArray *tasklists = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    [fetchRequest release];
    
    return [tasklists autorelease];
}
- (void)updateTasklistIdByNewId:(NSString *)oldId
                          newId:(NSString *)newId 
{
    Tasklist *tasklist = [self getTasklistById:oldId];
    if(tasklist == nil)
        return;
    tasklist.id = newId;
}
- (void)deleteTasklist:(Tasklist *)tasklist
{
    [context deleteObject:tasklist];
}
- (void)deleteAll
{
    NSMutableArray *array = [self getAllTasklist];
    
    if(array.count > 0)
        for(Tasklist* tasklist in array)
            [self deleteTasklist:tasklist];
}
- (Tasklist*)addTasklist:(NSString *)id :(NSString *)name :(NSString*)type
{
    Tasklist *tasklist = [ModelHelper create:tableName context:context];
    tasklist.id = id;
    tasklist.name = name;
    tasklist.listType = type;
    tasklist.editable = [NSNumber numberWithInt:1];
    if([[ConstantClass instance] username].length > 0)
        tasklist.accountId = [[ConstantClass instance] username];
    return tasklist;
}
- (void)adjustId:(NSString *)oldId withNewId:(NSString *)newId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context]; 
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %@)", oldId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil; 
    
    NSMutableArray *tasklists = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    if(tasklists.count > 0)
    {
        Tasklist *tasklist = [tasklists objectAtIndex:0];
        tasklist.id = newId;
    }
    
    [super commitData];
    
    [fetchRequest release];
}
- (void)updateEditable:(NSNumber *)editable tasklistId:(NSString *)tasklistId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context]; 
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    if([[ConstantClass instance] username].length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"(id = %@ and accountId = %@)"
                     , tasklistId, [[ConstantClass instance] username]];
    }
    else 
    {
        predicate = [NSPredicate predicateWithFormat:@"(id = %@ and accountId = nil)", tasklistId];
    }
    
   //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %@)", tasklistId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil; 
    
    NSMutableArray *tasklists = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    if(tasklists.count > 0)
    {
        Tasklist *tasklist = [tasklists objectAtIndex:0];
        tasklist.editable = editable;
    }
    
    [super commitData];
    
    [fetchRequest release];
}

@end
