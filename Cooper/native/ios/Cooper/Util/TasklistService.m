//
//  TasklistService.m
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "TasklistService.h"

@implementation TasklistService

+ (void)syncTasklist:(id)delegate
{
    //TODO:未实现
}

+ (void)getTasklists:(id)delegate
{
    NSString *url = [[[Constant instance] path] stringByAppendingFormat:GETTASKLISTS_URL];
    NSLog(@"getTasklists外部路径: %@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:nil WithInfo:nil addHeaders:nil];
}

@end
