//
//  ProjectDao.m
//  CooperRepository
//
//  Created by sunleepy on 12-9-14.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "ProjectDao.h"

@implementation ProjectDao
- (id)init
{
    if(self = [super init])
    {
        [super setContext];
        tableName = @"Project";
    }
    return self;
}

- (NSMutableArray*)getProjects
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
    
    NSMutableArray *projects = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    [fetchRequest release];
    
    return [projects autorelease];
}
- (void)addProject:(NSString*)teamId
                  :(NSString*)projectId
                  :(NSString*)projectName
{
    Project *project = [ModelHelper create:tableName context:context];
    project.teamId = teamId;
    project.id = projectId;
    project.name = projectName;
}
- (void)deleteProject:(Project*)project
{
    [context deleteObject:project];
}
- (void)deleteAll
{
    NSMutableArray *array = [self getProjects];
    
    if(array.count > 0)
    {
        for(Project* project in array)
        {
            [self deleteProject:project];
        }
    }
    
    [self commitData];
}

@end
