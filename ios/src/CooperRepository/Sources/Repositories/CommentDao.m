//
//  CommentDao.m
//  CooperRepository
//
//  Created by sunleepy on 12-9-19.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CommentDao.h"

@implementation CommentDao

- (id)init
{
    if(self = [super init])
    {
        [super setContext];
        tableName = @"Comment";
    }
    return self;
}

@end
