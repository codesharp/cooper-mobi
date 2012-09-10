//
//  TaslistNewService.h
//  CooperService
//
//  Created by sunleepy on 12-9-8.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@interface TasklistNewService : NSObject

- (void)getTasklists:(NSMutableDictionary*)context
            delegate:(id)delegate;

- (void)syncTasklists:(NSMutableDictionary*)context
                queue:(ASINetworkQueue*)networkQueue
             delegate:(id)delegate;

- (void)syncTasklists:(NSString*)tasklistId
              context:(NSMutableDictionary *)context
             delegate:(id)delegate;

@end
