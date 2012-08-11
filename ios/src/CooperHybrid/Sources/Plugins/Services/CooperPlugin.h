//
//  CooperPlugin.h
//  CooperHybrid
//
//  Created by sunleepy on 12-8-9.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif

#define LOGIN                           @"Login"
#define LOGOUT                          @"Logout"
#define SYNCTASKLISTS                   @"SyncTasklists"
#define SYNCTASKS                       @"SyncTasks"
#define GETNETWORKSTATUS                @"GetNetworkStatus"
#define GETCURRENTUSER                  @"GetCurrentUser"
#define GETTASKLISTS                    @"GetTasklists"
#define GETTASKLISTS_SERVER             @"GetTasklists_Server"
#define GETTASKSBYPRIORITY              @"GetTasksByPriority"
#define GETTASKSBYPRIORITY_SERVER       @"GetTasksByPriority_Server"
#define CREATETASKLIST                  @"CreateTasklist"
#define CREATETASK                      @"CreateTask"
#define UPDATETASK                      @"UpdateTask"
#define DELETETASK                      @"DeleteTask"

#define ANONYMOUS                       @"anonymous"
#define NORMAL                          @"normal"

@interface CooperPlugin : CDVPlugin

@property (atomic, assign) int tasklist_couter;
@property (atomic, assign) int tasklist_total;

- (void)refresh:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;

- (void)get:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;

- (void)save:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;

- (void)debug:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;

@end
