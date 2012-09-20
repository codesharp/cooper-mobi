//
//  ProjectDao.h
//  CooperRepository
//
//  Created by sunleepy on 12-9-14.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "RootDao.h"
#import "CooperCore/ModelHelper.h"
#import "CooperCore/Project.h"

@interface ProjectDao : RootDao
{
    NSString* tableName;
}

//获取所有项目信息
- (NSMutableArray*)getProjects;
//通过指定的TeamId获取项目信息
- (NSMutableArray*)getListByTeamId:(NSString*)teamId;
//通过指定的TeamId和ProjectId获取项目信息
- (Project*)getProjectByTeamId:(NSString*)teamId
                     projectId:(NSString*)projectId;
//添加项目
- (void)addProject:(NSString*)teamId
                  :(NSString*)projectId
                  :(NSString*)projectName;
//删除指定的项目
- (void)deleteProject:(Project*)project;
//删除所有项目
- (void)deleteAll;

@end
