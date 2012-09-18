//
//  TeamService.h
//  CooperService
//
//  Created by sunleepy on 12-9-14.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamService : NSObject

- (void)getTeams:(NSMutableDictionary*)context
            delegate:(id)delegate;

- (void)getTasks:(NSString*)teamId
       projectId:(NSString*)projectId
        memberId:(NSString*)memberId
             tag:(NSString*)tag
         context:(NSMutableDictionary*)context
        delegate:(id)delegate;

@end
