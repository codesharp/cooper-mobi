//
//  TeamService.h
//  CooperService
//
//  Created by sunleepy on 12-9-14.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamService : NSObject

//获取团队信息
- (void)getTeams:(NSMutableDictionary*)context
            delegate:(id)delegate;
//本地更改信息同步到服务端
- (void)syncTasks:(NSString*)teamId
        projectId:(NSString*)projectId
         memberId:(NSString*)memberId
              tag:(NSString*)tag
          context:(NSMutableDictionary*)context
         delegate:(id)delegate;
//获取指定TeamId的任务信息
- (void)getTasks:(NSString*)teamId
       projectId:(NSString*)projectId
        memberId:(NSString*)memberId
             tag:(NSString*)tag
         context:(NSMutableDictionary*)context
        delegate:(id)delegate;

@end
