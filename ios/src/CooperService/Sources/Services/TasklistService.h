//
//  TasklistService.h
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//


@interface TasklistService : NSObject

+ (void)syncTasklists:(NSString*)tasklistId context:(NSMutableDictionary *)context delegate:(id)delegate;

+ (void)syncTasklists:(NSMutableDictionary*)context delegate:(id)delegate;

+ (NSString*)syncTasklist:(NSString*)name :(NSString*)type :(id)delegate;

+ (void)getTasklists:(NSMutableDictionary*)context delegate:(id)delegate;

@end
