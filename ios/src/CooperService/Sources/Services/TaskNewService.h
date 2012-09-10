//
//  TaskNewService.h
//  CooperService
//
//  Created by sunleepy on 12-9-8.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@interface TaskNewService : NSObject

- (void)getAllTasks:(NSMutableArray*)tasklists
            context:(NSMutableDictionary*)context
              queue:(ASINetworkQueue*)networkQueue
           delegate:(id)delegate;

- (void)getTasks:(NSString*)tasklistId
         context:(NSMutableDictionary*)context
        delegate:(id)delegate;

- (void)syncTasks:(NSMutableArray*)tasklists
          context:(NSMutableDictionary*)context
            queue:(ASINetworkQueue*)networkQueue
         delegate:(id)delegate;

@end
