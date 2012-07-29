//
//  TaskDao.m
//  Cooper
//
//  Created by sunleepy on 12-7-6.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskDao.h"
#import "ModelHelper.h"
#import "Task.h"

@implementation TaskDao

- (id)init
{
    if(self = [super init])
    {
        [super setContext];
    }
    return self;
}

- (NSMutableArray*)getTaskByToday
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSString* todayString = [Tools ShortNSDateToNSString:[NSDate date]];
    
    NSDate* today = [Tools NSStringToShortNSDate:todayString];
    NSDate* tomorrow = [[NSDate alloc] initWithTimeInterval:24 * 60 * 60 sinceDate:today];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(status = 0) and ((dueDate != nil) and (dueDate >= %@) and (dueDate < %@))", today, tomorrow];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *tasks = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"error: %@", [error description]);
    
    [fetchRequest release];
    
    return [tasks autorelease];
}

- (NSMutableArray*)getAllTask:(NSString*)tasklistId
{
    NSLog(@"context retaincount: %d", [context retainCount]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    
    NSError *error = nil;
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(tasklistId = %@)", [NSString stringWithFormat:@"%@", tasklistId]];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *tasks = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"error: %@", [error description]);
    }
    
    NSLog(@"task count: %d", tasks.count);
    
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

- (void)deleteAll:(NSString*)tasklistId
{
    NSMutableArray *array = [self getAllTask:tasklistId];
    
    if(array.count > 0)
    {
        for(Task* task in array)
        {
            [self deleteTask:task];
        }
    }
}

- (void)addTask:(NSString *)subject 
     createDate:(NSDate*)createDate 
 lastUpdateDate:(NSDate*)lastUpdateDate 
           body:(NSString *)body 
       isPublic:(NSNumber *)isPublic 
         status:(NSNumber *)status 
       priority:(NSString *)priority 
         taskid:(NSString *)tid 
        dueDate:(NSDate *)dueDate
     tasklistId:(NSString*)tasklistId
       isCommit:(BOOL)isCommit
{
    Task *task = [ModelHelper create:@"Task" context:context];
    //TODO:...
    task.subject = subject;
    task.createDate = createDate;
    task.lastUpdateDate = lastUpdateDate;
    task.body = body;
    task.isPublic = isPublic;
    task.status = status;
    task.priority = priority;
    task.id = tid;
    task.dueDate = dueDate;
    task.tasklistId = tasklistId;
    
    if(isCommit)
        [super commitData];
}

- (void)updateTask:(Task*)task 
           subject:(NSString *)subject 
    lastUpdateDate:(NSData *)lastUpdateDate 
              body:(NSString *)body 
          isPublic:(NSNumber *)isPublic
            status:(NSNumber *)status
          priority:(NSString *)priority 
           dueDate:(NSDate *)dueDate
        tasklistId:(NSString*)tasklistId
          isCommit:(BOOL)isCommit
{
    task.subject = subject;
    task.lastUpdateDate = lastUpdateDate;
    task.body = body;
    task.isPublic = isPublic;
    task.status = status;
    task.priority = priority;
    task.dueDate = dueDate;
    task.tasklistId = tasklistId;
    
    if(isCommit)
        [super commitData];
}

- (void)updateTaskIdByNewId:(NSString *)oldId
                      newId:(NSString *)newId 
                 tasklistId:(NSString *)tasklistId
{
    Task *task = [self getTaskById:oldId];
    if(task == nil)
        return;
    task.id = newId;
    
    //[super commitData];
}

@end
