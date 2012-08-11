//
//  TaskService.h
//  Cooper
//
//  Created by sunleepy on 12-7-5.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@interface TaskService : NSObject

+ (void)getTasks:(NSString*)tasklistId 
         context:(NSMutableDictionary*)context 
        delegate:(id)delegate;

+ (void)syncTasks:(NSString*)tasklistId 
       changeLogs:(NSMutableArray*)changeLogs 
         taskIdxs:(NSMutableArray*)taskIdxs 
          context:(NSMutableDictionary*)context
         delegate:(id)delegate;

+ (void)syncTask:(NSString*)tasklistId 
         context:(NSMutableDictionary*)context
        delegate:(id)delegate;

+ (void)syncTaskByDict:(NSMutableDictionary *)dictionary delegate:(id)delegate;

@end
