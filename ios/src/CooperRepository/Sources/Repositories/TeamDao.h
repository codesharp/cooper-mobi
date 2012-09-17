//
//  TeamDao.h
//  CooperRepository
//
//  Created by sunleepy on 12-9-14.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "RootDao.h"
#import "CooperCore/ModelHelper.h"
#import "CooperCore/Team.h"

@interface TeamDao : RootDao
{
    NSString* tableName;
}

//获取所有团队信息
- (NSMutableArray*)getTeams;
//添加团队的信息
- (void)addTeam:(NSString*)teamId :(NSString*)name;
//删除指定的团队
- (void)deleteTeam:(Team*)team;
//删除所有团队
- (void)deleteAll;

@end
