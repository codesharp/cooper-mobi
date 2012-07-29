//
//  TasklistService.h
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//


@interface TasklistService : NSObject

+ (void)getTasklists:(id)delegate;

+ (void)syncTasklist:(id)delegate;

@end
