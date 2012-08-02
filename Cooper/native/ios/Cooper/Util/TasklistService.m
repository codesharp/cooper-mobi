//
//  TasklistService.m
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TasklistService.h"
#import "TasklistDao.h"

@implementation TasklistService

+ (NSString*)syncTasklist:(NSString*)name :(NSString*)type :(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:TASKLIST_URL_SYNC];
    NSLog(@"syncTasklist外部路径: %@", url);
 
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:name forKey:@"name"];
    [data setObject:type forKey:@"type"];
    
    //NSString *result = [NetworkManager doSynchronousPostRequest:url data:data];
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:nil addHeaders:nil];
    return @"";
}

+ (void)getTasklists:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:GETTASKLISTS_URL];
    NSLog(@"getTasklists外部路径: %@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:nil WithInfo:nil addHeaders:nil];
}

@end
