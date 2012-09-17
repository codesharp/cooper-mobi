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
//添加标签
- (void)addTag:(NSString*)tagName;
//删除指定的标签
- (void)deleteTag:(Tag *)tag;
//删除所有标签
- (void)deleteAll;

@end
