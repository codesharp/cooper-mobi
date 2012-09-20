//
//  TeamTaskViewDelegate.h
//  CooperNative
//
//  Created by sunleepy on 12-9-20.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@protocol TeamTaskViewDelegate

- (void)startSync:(NSString*)teamId
        projectId:(NSString*)projectId
         memberId:(NSString*)memberId
              tag:(NSString*)tag;

@end
