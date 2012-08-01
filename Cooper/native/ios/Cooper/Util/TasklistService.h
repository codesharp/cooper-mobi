//
//  TasklistService.h
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//


@interface TasklistService : NSObject

+ (NSString*)syncTasklist:(NSString*)name :(NSString*)type :(id)delegate;

+ (void)getTasklists:(id)delegate;

@end
