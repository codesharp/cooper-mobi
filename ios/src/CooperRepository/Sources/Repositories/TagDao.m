//
//  TagDao.m
//  CooperRepository
//
//  Created by sunleepy on 12-9-17.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TagDao.h"

@implementation TagDao

- (id)init
{
    if(self = [super init])
    {
        [super setContext];
        tableName = @"Tag";
    }
    return self;
}

- (NSMutableArray*)getTags
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
//    NSSortDescriptor *sortDescriptor =  [[NSSortDescriptor alloc] initWithKey:@"name"
//                                                                    ascending:YES];
//    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    
    NSMutableArray *tags = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    [fetchRequest release];
    
    return tags;
}
- (NSMutableArray*)getListByTeamId:(NSString*)teamId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    NSError *error = nil;
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(teamId = %@)", teamId];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *tags = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"数据库错误异常: %@", [error description]);
    }
    
    [fetchRequest release];
    
    return tags;
}
- (Tag*)getTagByTeamId:(NSString*)teamId tag:(NSString*)name
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    NSError *error = nil;
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(teamId = %@ and name = %@)", name];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *tags = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"数据库错误异常: %@", [error description]);
    }
    
    Tag *tag = nil;
    if(tags.count > 0)
    {
        tag = [tags objectAtIndex:0];
    }
    
    [fetchRequest release];
    
    return tag;
}
- (void)addTag:(NSString *)tagName teamId:(NSString*)teamId
{
    Tag *tag = [ModelHelper create:tableName context:context];
    tag.name = tagName;
    tag.teamId = teamId;
}
- (void)deleteTag:(Tag*)tag
{
    [context deleteObject:tag];
}
- (void)deleteAll
{
    NSMutableArray *array = [self getTags];
    
    if(array.count > 0)
    {
        for(Tag* tag in array)
        {
            [self deleteTag:tag];
        }
    }
    
    [self commitData];
}

@end
