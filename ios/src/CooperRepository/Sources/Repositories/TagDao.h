//
//  TagDao.h
//  CooperRepository
//
//  Created by sunleepy on 12-9-17.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "RootDao.h"
#import "CooperCore/ModelHelper.h"
#import "CooperCore/Tag.h"

@interface TagDao : RootDao
{
    NSString* tableName;
}

//获取所有标签信息
- (NSMutableArray*)getTags;
//通过指定的TeamId获取标签信息
- (NSMutableArray*)getListByTeamId:(NSString*)teamId;
//通过指定的Tag获取标签信息
- (Tag*)getTagByTeamId:(NSString*)teamId tag:(NSString*)tag;
//添加标签
- (void)addTag:(NSString*)tagName teamId:(NSString*)teamId;
//删除指定的标签
- (void)deleteTag:(Tag *)tag;
//删除所有标签
- (void)deleteAll;

@end
