//
//  TeamDao.m
//  CooperRepository
//
//  Created by sunleepy on 12-9-14.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TeamDao.h"

@implementation TeamDao

- (id)init
{
    if(self = [super init])
    {
        [super setContext];
        tableName = @"Team";
    }
    return self;
}

- (NSMutableArray*)getTeams
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor =  [[NSSortDescriptor alloc] initWithKey:@"id"
                                                                    ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    
    NSMutableArray *teams = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    [fetchRequest release];
    
    return [teams autorelease];
}
- (void)addTeam:(NSString*)teamId :(NSString*)name
{
    Team *team = [ModelHelper create:tableName context:context];
    team.id = teamId;
    team.name = name;
}
- (void)deleteTeam:(Team*)team
{
    [context deleteObject:team];
}
- (void)deleteAll
{
    NSMutableArray *array = [self getTeams];
    
    if(array.count > 0)
    {
        for(Team* team in array)
        {
            [self deleteTeam:team];
        }
    }
    
    [self commitData];
}

@end
