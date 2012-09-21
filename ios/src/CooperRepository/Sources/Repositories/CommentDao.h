//
//  CommentDao.h
//  CooperRepository
//
//  Created by sunleepy on 12-9-19.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "RootDao.h"
#import "CooperCore/ModelHelper.h"
#import "CooperCore/Comment.h"

@interface CommentDao : RootDao
{
    NSString* tableName;
}

- (NSMutableArray*)getListByTaskId:(NSString*)taskId;
- (NSMutableArray*)getComments;
- (void)deleteComment:(Comment*)comment;
- (void)deleteAll;
- (void)addComment:(NSString*)taskId
         creatorId:(NSString*)creatorId
        createTime:(NSDate*)createTime
              body:(NSString*)body;
- (void)addComment:(NSString*)taskId
        createTime:(NSDate*)createTime
              body:(NSString*)body;

@end
