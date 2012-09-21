//
//  TeamMemberDao.m
//  CooperRepository
//
//  Created by sunleepy on 12-9-14.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TeamMemberDao.h"

@implementation TeamMemberDao

- (id)init
{
    if(self = [super init])
    {
        [super setContext];
        tableName = @"TeamMember";
    }
    return self;
}

- (NSMutableArray*)getTeamMembers
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
//    NSSortDescriptor *sortDescriptor =  [[NSSortDescriptor alloc] initWithKey:@"id"
//                                                                    ascending:YES];
//    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    
    NSMutableArray *teamMembers = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    [fetchRequest release];
    
    return [teamMembers autorelease];
}
- (NSMutableArray*)getListByTeamId:(NSString*)teamId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    NSError *error = nil;
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(teamId = %@)", teamId];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *teamMembers = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"数据库错误异常: %@", [error description]);
    }
    
    [fetchRequest release];
    
    return teamMembers;
}
- (TeamMember*)getTeamMemberByTeamId:(NSString*)teamId
                                   name:(NSString*)name
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    NSError *error = nil;
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(teamId = %@ and name = %@)", teamId, name];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *teamMembers = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"数据库错误异常: %@", [error description]);
    }
    
    TeamMember *teamMember = nil;
    if (teamMembers.count > 0) {
        teamMember = [teamMembers objectAtIndex:0];
    }
    
    [fetchRequest release];
    
    return teamMember;
}
- (TeamMember*)getTeamMemberByTeamId:(NSString*)teamId
                        assigneeId:(NSString*)assigneeId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    NSError *error = nil;
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(teamId = %@ and id = %@)", teamId, assigneeId];
    [fetchRequest setPredicate:predicate];
    
    NSMutableArray *teamMembers = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"数据库错误异常: %@", [error description]);
    }
    
    TeamMember *teamMember = nil;
    if (teamMembers.count > 0) {
        teamMember = [teamMembers objectAtIndex:0];
    }
    
    [fetchRequest release];
    
    return teamMember;
}
- (void)addTeamMember:(NSString*)teamId
                     :(NSString*)memberId
                     :(NSString*)memberName
                     :(NSString*)memberEmail
{
    TeamMember *teamMember = [ModelHelper create:tableName context:context];
    teamMember.teamId = teamId;
    teamMember.id = memberId;
    teamMember.name = memberName;
    teamMember.email = memberEmail;
}
- (void)deleteTeamMember:(TeamMember*)teamMember
{
    [context deleteObject:teamMember];
}
- (void)deleteAll
{
    NSMutableArray *array = [self getTeamMembers];
    
    if(array.count > 0)
    {
        for(TeamMember *teamMember in array)
        {
            [self deleteTeamMember:teamMember];
        }
    }
}

@end
