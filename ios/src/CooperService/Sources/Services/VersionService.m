//
//  VersionService.m
//  CooperService
//
//  Created by sunleepy on 12-8-21.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "VersionService.h"

@implementation VersionService

+ (void)getCurrentAppVersion:(NSMutableDictionary*)context
                    delegate:(id)delegate   
{
    NSString* url = @"https://xyj.im";
    NSLog(@"验证版本请求: %@", url);
    
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:nil WithInfo:context addHeaders:nil];
}

@end
