//
//  TaskIdxDao.m
//  Cooper
//
//  Created by sunleepy on 12-7-6.
//  Copyright (c) 2012年 alibaba. All rights reserved.
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
    }
    return self;
}

- (NSMutableArray*)getAllTaskIdx
{
    NSLog(@"context retaincount: %d", [context retainCount]);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskIdx" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor =  [[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil; 
    NSMutableArray *taskIdxs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    [fetchRequest release];

    return [taskIdxs autorelease];
}

- (TaskIdx*)getTaskIdxByKey:(NSString*)key
{
    NSLog(@"context retaincount: %d", [context retainCount]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskIdx" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(key = %@)", key];
    [fetchRequest setPredicate:predicate];

    TaskIdx *idxs = nil;
    
    NSError *error = nil; 
    NSMutableArray *taskIdxs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if (taskIdxs.count == 0) {
        NSLog(@"taskidx not exists.");
        idxs = [ModelHelper create:@"TaskIdx" context:context];
    }
    else {
        NSLog(@"taskidx already record. %d", taskIdxs.count);
        NSLog(@"item:%@", [[taskIdxs objectAtIndex:0] class]);
        idxs = [taskIdxs objectAtIndex:0];
    }
    
    [fetchRequest release];

    return idxs;
}

- (void)updateTaskIdx:(NSString *)taskId byKey:(NSString *)key isCommit:(BOOL)isCommit
{
    NSLog(@"context retaincount: %d", [context retainCount]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskIdx" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
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
        
        NSLog(@"taskIdx.key %@, key %@",taskIdx.key, key);
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

- (void)addTaskIdx:(NSString *)tid byKey:(NSString *)key isCommit:(BOOL)isCommit
{
    NSLog(@"context retaincount: %d", [context retainCount]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskIdx" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(key = %@)", key];
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
        taskIdx.name = [key isEqualToString:@"0"] ? (@"今天") : ([key isEqualToString:@"1"] ? @"稍后完成" : @"迟些再说");
        NSLog(@"taskIdx.name:%@", taskIdx.name);
        indexesArray = [NSMutableArray array];
    }
    else 
    {
        taskIdx = [taskIdxs objectAtIndex:0];
        if(!taskIdx.indexes)
            indexesArray = [NSMutableArray array];
        else
            indexesArray = [parser objectWithString: taskIdx.indexes];  
        NSLog(@"has taskIdx Index: %@", taskIdx.key);
    }
    [indexesArray addObject:tid];
    taskIdx.indexes = [writer stringWithObject:indexesArray];
    NSLog(@"indexes:", taskIdx.indexes);

    if(isCommit)
        [super commitData];

    [fetchRequest release];
    [writer release];
    [parser release];
}

- (void)addTaskIdx:(NSString *)by key:(NSString *)key name:(NSString *)name indexes:(NSString *)indexes
{
    TaskIdx *taskIdx = [ModelHelper create:@"TaskIdx" context:context];
    [taskIdx setKey:key];
    [taskIdx setBy:by];
    [taskIdx setName:name];
    [taskIdx setIndexes:indexes];
}

- (void)deleteTaskIndexsByTaskId:(NSString *)taskId
{
    NSLog(@"context retaincount: %d", [context retainCount]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskIdx" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil; 
    NSMutableArray *taskIdxs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    for(TaskIdx *taskIdx in taskIdxs)
    {
        BOOL isChanged = NO;
        //if(!taskIdx.indexes)
        //    taskIdx.indexes = [NSMutableArray array];
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

- (void)deleteAllTaskIdx
{
    NSLog(@"context retaincount: %d", [context retainCount]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskIdx" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil; 
    NSMutableArray *taskIdxs = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(taskIdxs.count > 0)
    {
        for(TaskIdx *taskIdx in taskIdxs)
            [context deleteObject:taskIdx];
    }
}

- (void) adjustIndex:(NSString *)taskId sourceTaskIdx:(TaskIdx *)sTaskIdx destinationTaskIdx:(TaskIdx *)dTaskIdx sourceIndexRow:(NSNumber*)sourceIndexRow destIndexRow:(NSNumber *)destIndexRow
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    

        NSMutableArray *sIndexesArray = [parser objectWithString: sTaskIdx.indexes];
        if([sIndexesArray containsObject:taskId])
            [sIndexesArray removeObject:taskId];
        sTaskIdx.indexes = [writer stringWithObject:sIndexesArray];  
        
        NSMutableArray *dIndexesArray = [parser objectWithString: dTaskIdx.indexes];
        [dIndexesArray insertObject:taskId atIndex:destIndexRow];
        dTaskIdx.indexes = [writer stringWithObject:dIndexesArray];
        

    [writer release];
    [parser release];
}

- (void)saveIndex:(TaskIdx *)taskIdx newIndex:(NSMutableArray *)indexArray
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    
    NSMutableArray *allTaskIdxs = [self getAllTaskIdx];
    
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

- (void)updateTaskIdxByNewId:(NSString *)oldId newId:(NSString *)newId
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    
    NSMutableArray *array = [self getAllTaskIdx];
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
