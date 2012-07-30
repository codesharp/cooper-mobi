//
//  TasklistDao.m
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "TasklistDao.h"
#import "ModelHelper.h"
#import "Tasklist.h"


@implementation TasklistDao

- (id)init
{
    if(self = [super init])
    {
        [super setContext];
    }
    return self;
}

- (NSMutableArray*)getAllTasklist
{
    NSLog(@"context retaincount: %d", [context retainCount]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tasklist" inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor =  [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil; 
    [fetchRequest setEntity:entity];
    NSMutableArray *tasklists = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"error: %@", [error description]);
    }
    
    [fetchRequest release];
    
    return [tasklists autorelease];
}

//- (NSMutableArray*)getAllLocalTasklist
//{
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tasklist" inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//
//    
//    NSError *error = nil; 
//
//    NSMutableArray *tasklists = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
//    if(error != nil)
//    {
//        NSLog(@"error: %@", [error description]);
//    }
//    
//}

- (void)deleteTasklist:(Tasklist *)tasklist
{
    NSLog(@"context retaincount: %d", [context retainCount]);
    [context deleteObject:tasklist];
}

- (void)deleteAll
{
    NSMutableArray *array = [self getAllTasklist];
    
    if(array.count > 0)
    {
        for(Tasklist* tasklist in array)
        {
            [self deleteTasklist:tasklist];
        }
    }
}

- (void)addTasklist:(NSString *)id :(NSString *)name :(NSString*)type
{
    Tasklist *tasklist = [ModelHelper create:@"Tasklist" context:context];
    tasklist.id = id;
    tasklist.name = name;
    tasklist.listType = type;

    //[super commitData];
}

- (void)adjustId:(NSString *)oldId withNewId:(NSString *)newId
{
    NSLog(@"context retaincount: %d", [context retainCount]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tasklist" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %@)", oldId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil; 
    
    NSMutableArray *tasklists = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"error: %@", [error description]);
    }
    
    if(tasklists.count > 0)
    {
        Tasklist *tasklist = [tasklists objectAtIndex:0];
        tasklist.id = newId;
    }
    
    [super commitData];
    
    [fetchRequest release];
}

@end
