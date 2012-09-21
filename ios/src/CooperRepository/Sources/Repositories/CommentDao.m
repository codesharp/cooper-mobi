//
//  CommentDao.m
//  CooperRepository
//
//  Created by sunleepy on 12-9-19.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CommentDao.h"

@implementation CommentDao

- (id)init
{
    if(self = [super init])
    {
        [super setContext];
        tableName = @"Comment";
    }
    return self;
}

- (NSMutableArray*)getListByTaskId:(NSString*)taskId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor =  [[NSSortDescriptor alloc] initWithKey:@"createTime"
                                                                    ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(taskId = %@)", taskId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *comments = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"数据库错误异常: %@", [error description]);
    }
    
    [fetchRequest release];
    
    return comments;
}
- (NSMutableArray*)getComments
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    
    NSMutableArray *comments = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    [fetchRequest release];
    
    return comments;
}
- (void)addComment:(NSString*)taskId
         creatorId:(NSString*)creatorId
        createTime:(NSDate*)createTime
              body:(NSString*)body
{
    Comment *comment = [ModelHelper create:tableName context:context];
    comment.taskId = taskId;
    comment.creatorId = creatorId;
    comment.createTime = createTime;
    comment.body = body;
}
- (void)addComment:(NSString*)taskId
        createTime:(NSDate*)createTime
              body:(NSString*)body
{
    Comment *comment = [ModelHelper create:tableName context:context];
    comment.taskId = taskId;
    comment.createTime = createTime;
    comment.body = body;
}
- (void)deleteComment:(Comment*)comment
{
    [context deleteObject:comment];
}
- (void)deleteAll
{
    NSMutableArray *array = [self getComments];
    
    if(array.count > 0)
    {
        for(Comment* comment in array)
        {
            [self deleteComment:comment];
        }
    }
    
    [self commitData];
}

@end
