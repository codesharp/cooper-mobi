//
//  TaskDao.m
//  Cooper
//
//  Created by sunleepy on 12-7-6.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskDao.h"
#import "CooperCore/ModelHelper.h"
#import "CooperCore/Task.h"

@implementation TaskDao

- (id)init
{
    if(self = [super init])
    {
        [super setContext];
        tableName = @"Task";
    }
    return self;
}

- (NSMutableArray*)getTaskByToday
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSString* todayString = [Tools ShortNSDateToNSString:[NSDate date]];
    
    NSDate* today = [Tools NSStringToShortNSDate:todayString];
    NSDate* tomorrow = [[NSDate alloc] initWithTimeInterval:24 * 60 * 60 sinceDate:today];
    
    NSPredicate *predicate;
    if([[ConstantClass instance] username].length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"(status = 0) and ((dueDate != nil) and (dueDate >= %@) and (dueDate < %@) and (accountId = %@))", today, tomorrow, [[ConstantClass instance] username]];
    }
    else 
    {
        predicate = [NSPredicate predicateWithFormat:@"(status = 0) and ((dueDate != nil) and (dueDate >= %@) and (dueDate < %@) and (accountId = nil))", today, tomorrow];
    }
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *tasks = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    [fetchRequest release];
    
    return [tasks autorelease];
}

- (NSMutableArray*)getAllTask:(NSString*)tasklistId
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
    
    NSMutableArray *tasks = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"数据库错误异常: %@", [error description]);
    }
    
    [fetchRequest release];
    
    return [tasks autorelease];
}

- (Task*)getTaskById:(NSString*)taskId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    NSError *error = nil;
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %@)", [NSString stringWithFormat:@"%@", taskId]];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *tasks = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"数据库错误异常: %@", [error description]);
    }

    Task *task = nil;
    if (tasks.count == 0) {
        task = [ModelHelper create:tableName context:context];
    }
    else {
        task = (Task*)[tasks objectAtIndex:0];
    }

    [fetchRequest release];
    
    return task;
}

- (void)deleteTask:(Task *)task
{
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

- (void)saveTask:(NSString*)taskId
         subject:(NSString*)subject
  lastUpdateDate:(NSDate*)lastUpdateDate
            body:(NSString *)body 
        isPublic:(NSNumber *)isPublic 
          status:(NSNumber *)status 
        priority:(NSString *)priority 
         dueDate:(NSDate *)dueDate
        editable:(NSNumber *)editable
      tasklistId:(NSString*)tasklistId
{
    Task *task = [self getTaskById:taskId];

    if(task.id.length == 0)
    {
        NSDate *currentDate = [NSDate date];
        [self addTask:subject createDate:currentDate lastUpdateDate:lastUpdateDate body:body isPublic:isPublic status:status priority:priority taskid:taskId dueDate:dueDate editable:editable tasklistId:tasklistId isCommit:NO];
    }
    else 
    {
        [self updateTask:task 
                 subject:subject 
          lastUpdateDate:lastUpdateDate 
                    body:body 
                isPublic:isPublic 
                  status:status 
                priority:priority 
                 dueDate:dueDate 
              tasklistId:tasklistId 
                isCommit:NO];
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
       editable:(NSNumber *)editable
     tasklistId:(NSString*)tasklistId
       isCommit:(BOOL)isCommit
{
    Task *task = [ModelHelper create:tableName context:context];
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
    task.editable = editable;
    task.tasklistId = tasklistId;
    if([[ConstantClass instance] username].length > 0)
        task.accountId = [[ConstantClass instance] username];
    
    if(isCommit)
        [super commitData];
}

- (void)updateTask:(Task*)task 
           subject:(NSString *)subject 
    lastUpdateDate:(NSDate *)lastUpdateDate 
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
    if([[ConstantClass instance] username].length > 0)
        task.accountId = [[ConstantClass instance] username];
    
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
