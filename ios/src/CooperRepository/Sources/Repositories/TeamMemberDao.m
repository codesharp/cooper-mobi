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
    
    NSSortDescriptor *sortDescriptor =  [[NSSortDescriptor alloc] initWithKey:@"id"
                                                                    ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    
    NSMutableArray *teamMembers = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if(error != nil)
        NSLog(@"数据库错误异常: %@", [error description]);
    
    [fetchRequest release];
    
    return [teamMembers autorelease];
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
- (NSMutableArray*)getListByTeamId
{
    return nil;
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
