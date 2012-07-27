//
//  TaskDao.m
//  Cooper
//
//  Created by sunleepy on 12-7-6.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskDao.h"
#import "ModelHelper.h"

@implementation TaskDao

- (id)init
{
    if(self = [super init])
    {
        [super setContext];
    }
    return self;
}

- (NSMutableArray*)getAllTask
{
    NSLog(@"context retaincount: %d", [context retainCount]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    
    NSError *error = nil;
    
    [fetchRequest setEntity:entity];
    NSMutableArray *tasks = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"error: %@", [error description]);
    }
    
    [fetchRequest release];
    
    return [tasks autorelease];
}

- (Task*)getTaskById:(NSString*)taskId
{
    NSLog(@"context retaincount: %d", [context retainCount]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    
    NSError *error = nil;
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %@)", [NSString stringWithFormat:@"%@", taskId]];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *tasks = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"error: %@", [error description]);
    }

    Task *task = nil;
    if (tasks.count == 0) {
        NSLog(@"task not exists.");
        task = [ModelHelper create:@"Task" context:context];
    }
    else {
        NSLog(@"task already record.");
        NSLog(@"count:%d", tasks.count);
        task = (Task*)[tasks objectAtIndex:0];
    }

    [fetchRequest release];
    
    return task;
}

- (void)deleteTask:(Task *)task
{
    NSLog(@"context retaincount: %d", [context retainCount]);
    [context deleteObject:task];
}

- (void)deleteAll
{
    NSMutableArray *array = [self getAllTask];
    
    if(array.count > 0)
    {
        for(Task* task in array)
        {
            [self deleteTask:task];
        }
    }
}

- (void)addTask:(NSString *)subject 
     createDate:(NSData*)createDate 
 lastUpdateDate:(NSData*)lastUpdateDate 
           body:(NSString *)body isPublic:(NSNumber *)isPublic status:(NSNumber *)status priority:(NSString *)priority taskid:(NSString *)tid dueDate:(NSDate *)dueDate isCommit:(BOOL)isCommit
{
    Task *task = [ModelHelper create:@"Task" context:context];
    //TODO:...
    [task setSubject:subject];
    [task setCreateDate:createDate];
    [task setLastUpdateDate:lastUpdateDate];
    [task setBody:body];
    [task setIsPublic:isPublic];
    [task setStatus:status];
    [task setPriority:priority];
    [task setId:tid];
    [task setDueDate:dueDate];
    
    if(isCommit)
        [super commitData];
}

- (void)updateTask:(Task*)task subject:(NSString *)subject lastUpdateDate:(NSData *)lastUpdateDate body:(NSString *)body isPublic:(NSNumber *)isPublic status:(NSNumber *)status priority:(NSString *)priority dueDate:(NSDate *)dueDate isCommit:(BOOL)isCommit
{
    [task setSubject:subject];
    [task setLastUpdateDate:lastUpdateDate];
    [task setBody:body];
    [task setIsPublic:isPublic];
    [task setStatus:status];
    [task setPriority:priority];
    [task setDueDate:dueDate];
    
    if(isCommit)
        [super commitData];
}

- (void)updateTaskIdByNewId:(NSString *)oldId newId:(NSString *)newId
{
    Task *task = [self getTaskById:oldId];
    if(task == nil)
        return;
    task.id = newId;
    
    //[super commitData];
}

@end
