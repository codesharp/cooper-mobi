//
//  TaskIdxDao.m
//  Cooper
//
//  Created by sunleepy on 12-7-6.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskIdxDao.h"
#import "SBJsonParser.h"
#import "SBJsonWriter.h"
#import "ModelHelper.h"

@implementation TaskIdxDao

- (id)init
{
    if(self = [super init])
    {
        [super setContext];
        tableName = @"TaskIdx";
    }
    return self;
}

- (NSMutableArray*)getAllTaskIdx:(NSString*)tasklistId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    
    if([[ConstantClass instance] username].length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"((tasklistId = %@) and (accountId = %@))", tasklistId, [[ConstantClass instance] username]];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"(tasklistId = %@ and accountId = nil)",tasklistId];
    }
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor =  [[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil; 
    NSMutableArray *taskIdxs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    [fetchRequest release];

    return [taskIdxs autorelease];
}

- (TaskIdx*)getTaskIdxByKey:(NSString*)key tasklistId:(NSString *)tasklistId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    if([[ConstantClass instance] username].length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"(key = %@ and tasklistId = %@ and accountId = %@)", key, tasklistId, [[ConstantClass instance] username]];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"(key = %@ and tasklistId = %@ and accountId = nil)", key, tasklistId];
    }
    [fetchRequest setPredicate:predicate];

    TaskIdx *idxs = nil;
    
    NSError *error = nil; 
    NSMutableArray *taskIdxs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if (taskIdxs.count == 0) {
        idxs = [ModelHelper create:tableName context:context];
    }
    else {
        idxs = [taskIdxs objectAtIndex:0];
    }
    
    [fetchRequest release];

    return idxs;
}

- (void)updateTaskIdx:(NSString *)taskId 
                byKey:(NSString *)key 
           tasklistId:(NSString*)tasklistId
             isCommit:(BOOL)isCommit
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
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
    
    NSError *error = nil; 
    NSMutableArray *taskIdxs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    for(TaskIdx *taskIdx in taskIdxs)
    {
        BOOL isChanged = NO;
        NSMutableArray *indexesArray = [parser objectWithString: taskIdx.indexes];
        if([indexesArray containsObject:taskId])
        {
            [indexesArray removeObject:taskId];
            isChanged = YES;
        }
        
        if([taskIdx.key isEqualToString:key])
        {
            
            [indexesArray addObject:taskId];
            isChanged = YES;
        }
        if(isChanged)
            taskIdx.indexes = [writer stringWithObject:indexesArray]; 
    }
    
    if(isCommit)
        [super commitData];
    
    [fetchRequest release];
    [writer release];
    [parser release];
}

- (void)addTaskIdx:(NSString *)tid 
             byKey:(NSString *)key 
        tasklistId:(NSString*)tasklistId
          isCommit:(BOOL)isCommit
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSPredicate *predicate;
    if([[ConstantClass instance] username].length > 0)
    {
        predicate = [NSPredicate predicateWithFormat:@"(key = %@ and tasklistId = %@ and accountId = %@)", key, tasklistId,[[ConstantClass instance] username]];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"(key = %@ and tasklistId = %@ and accountId = nil)", key, tasklistId];
    }
    [fetchRequest setPredicate:predicate];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    
    NSError *error = nil; 
    NSMutableArray *taskIdxs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    TaskIdx *taskIdx = nil;
    NSMutableArray *indexesArray = nil;
    if(taskIdxs.count == 0)
    {
        taskIdx = [ModelHelper create:@"TaskIdx" context:context];
        taskIdx.by = @"priority";
        taskIdx.key = key;
        taskIdx.name = [key isEqualToString:@"0"] ? (PRIORITY_TITLE_1) : ([key isEqualToString:@"1"] ?PRIORITY_TITLE_2 : PRIORITY_TITLE_3);
        indexesArray = [NSMutableArray array];
    }
    else 
    {
        taskIdx = [taskIdxs objectAtIndex:0];
        if(!taskIdx.indexes)
            indexesArray = [NSMutableArray array];
        else
            indexesArray = [parser objectWithString: taskIdx.indexes];  
    }
    [indexesArray addObject:tid];
    taskIdx.indexes = [writer stringWithObject:indexesArray];
    taskIdx.tasklistId = tasklistId;

    if(isCommit)
        [super commitData];

    [fetchRequest release];
    [writer release];
    [parser release];
}

- (void)addTaskIdx:(NSString *)by 
               key:(NSString *)key 
              name:(NSString *)name 
           indexes:(NSString *)indexes
        tasklistId:(NSString *)tasklistId
{
    TaskIdx *taskIdx = [ModelHelper create:tableName context:context];
    taskIdx.key = key;
    taskIdx.by = by;
    taskIdx.name = name;
    taskIdx.indexes = indexes;
    taskIdx.tasklistId = tasklistId;
    if([[ConstantClass instance] username].length > 0)
        taskIdx.accountId = [[ConstantClass instance] username];
}

- (void)deleteTaskIndexsByTaskId:(NSString *)taskId 
                      tasklistId:(NSString *)tasklistId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
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
    
    NSError *error = nil; 
    NSMutableArray *taskIdxs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    for(TaskIdx *taskIdx in taskIdxs)
    {
        BOOL isChanged = NO;
        NSMutableArray *indexesArray = [parser objectWithString: taskIdx.indexes];
        if([indexesArray containsObject:taskId])
        {
            [indexesArray removeObject:taskId];
            isChanged = YES;
        }
        
        if(isChanged)
            taskIdx.indexes = [writer stringWithObject:indexesArray]; 
    }
    
    [fetchRequest release];
    [writer release];
    [parser release];
}

- (void)deleteAllTaskIdx:(NSString*)tasklistId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
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
    
    NSError *error = nil; 
    NSMutableArray *taskIdxs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(taskIdxs.count > 0)
    {
        for(TaskIdx *taskIdx in taskIdxs)
            [context deleteObject:taskIdx];
    }
}

- (void) adjustIndex:(NSString *)taskId 
       sourceTaskIdx:(TaskIdx *)sTaskIdx 
  destinationTaskIdx:(TaskIdx *)dTaskIdx 
      sourceIndexRow:(NSNumber*)sourceIndexRow 
        destIndexRow:(NSNumber*)destIndexRow
          tasklistId:(NSString*)tasklistId
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    

        NSMutableArray *sIndexesArray = [parser objectWithString: sTaskIdx.indexes];
        if([sIndexesArray containsObject:taskId])
            [sIndexesArray removeObject:taskId];
        sTaskIdx.indexes = [writer stringWithObject:sIndexesArray];  
        
        NSMutableArray *dIndexesArray = [parser objectWithString: dTaskIdx.indexes];
        [dIndexesArray insertObject:taskId atIndex:[destIndexRow integerValue]];
        dTaskIdx.indexes = [writer stringWithObject:dIndexesArray];
        

    [writer release];
    [parser release];
}

- (void)saveIndex:(TaskIdx *)taskIdx 
         newIndex:(NSMutableArray *)indexArray
       tasklistId:(NSString *)tasklistId
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    
    NSMutableArray *allTaskIdxs = [self getAllTaskIdx:tasklistId];
    
    if(taskIdx.indexes)
    {
        NSMutableArray *sIndexesArray = [parser objectWithString: taskIdx.indexes];
        for(NSString *taskId in indexArray)
        {
            if([sIndexesArray containsObject:taskId])
            {
                continue;
            }
            
            for(TaskIdx *tempTaskIdx in allTaskIdxs)
            {
                if([tempTaskIdx.key isEqualToString:taskIdx.key])
                    continue;
                    
                NSMutableArray *tempArray = [parser objectWithString:tempTaskIdx.indexes];
                if(!tempTaskIdx.indexes)
                {
                    BOOL isChanged = NO;
                    for (int i = 0; i < tempArray.count; i++) {
                        NSString *t = [tempArray objectAtIndex:i];
                        if([t isEqualToString:taskId])
                        {
                            isChanged = YES;
                            [tempArray removeObject:taskId];
                            break;
                        }
                    }
                    
                    if(isChanged)
                    {
                        tempTaskIdx.indexes = [writer stringWithObject:tempArray];
                    }
                }
            }
            
            
            [sIndexesArray addObject:taskId];
        }
        taskIdx.indexes = [writer stringWithObject:sIndexesArray];
    }
    else 
    {
        taskIdx.indexes = [indexArray JSONRepresentation];
    }
    [writer release];
    [parser release];
}

- (void)updateTaskIdxByNewId:(NSString *)oldId 
                       newId:(NSString *)newId
                  tasklistId:(NSString *)tasklistId

{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    
    NSMutableArray *array = [self getAllTaskIdx:tasklistId];
    for(TaskIdx *taskIdx in array)
    {
        NSMutableArray *sIndexesArray = [parser objectWithString: taskIdx.indexes];
        int i = 0;
        
        for(NSString *taskId in sIndexesArray)
        {
            if([taskId isEqualToString: oldId])
            {
                [sIndexesArray replaceObjectAtIndex:i withObject:newId];
                break;
            }
            i++;
        }
        taskIdx.indexes = [writer stringWithObject:sIndexesArray];
    }
    
    [parser release];
    [writer release];
}

@end
