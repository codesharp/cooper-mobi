//
//  TeamMemberDao.h
//  CooperRepository
//
//  Created by sunleepy on 12-9-14.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "RootDao.h"
#import "CooperCore/ModelHelper.h"
#import "CooperCore/TeamMember.h"

@interface TeamMemberDao : RootDao
{
    NSString *tableName;
}

//获取所有
- (NSMutableArray*)getTeamMembers;
//通过团队编号获取成员列表
- (NSMutableArray*)getListByTeamId:(NSString*)teamId;
- (TeamMember*)getTeamMemberByTeamId:(NSString*)teamId
                                   email:(NSString*)email;
//通过团队编号和AssigneeId获取成员
- (TeamMember*)getTeamMemberByTeamId:(NSString*)teamId
                          assigneeId:(NSString*)assigneeId;
//添加团队成员
- (void)addTeamMember:(NSString*)teamId
                     :(NSString*)memberId
                     :(NSString*)memberName
                     :(NSString*)memberEmail;
//删除制定的团队成员
- (void)deleteTeamMember:(TeamMember*)teamMember;
//删除所有的成员
- (void)deleteAll;

@end
