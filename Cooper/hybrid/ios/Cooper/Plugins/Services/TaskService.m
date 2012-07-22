//
//  TaskService.m
//  CooperGap
//
//  Created by sunleepy on 12-7-20.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskService.h"
#import "Constant.h"
#import "NetworkManager.h"

@implementation TaskService

@synthesize callbackId;

- (void)getTasks:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    self.callbackId = [arguments objectAtIndex:0];
    
    NSString *url = [[[Constant instance] path] stringByAppendingFormat:TASK_URL_GETBYPRIORITY];
    NSLog(@"url:%@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:self data:nil WithInfo:nil];
}

- (void)addRequstToPool:(ASIHTTPRequest *)request {
    //    [requestPool addObject:request];
    NSLog(@"发送请求：%@",request.url);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"response data: %@, %d", [request responseString], [request responseStatusCode]);
    
    NSDictionary *dictionary = [[request responseString] JSONValue];
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: dictionary];
    NSString *jsString = [result toSuccessCallbackString:self.callbackId];
    //NSLog(@"jsString:%@", jsString);
    [request.delegate writeJavascript:jsString];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request error: %@", request.error);
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"failed"];
    NSString *jsString = [result toSuccessCallbackString:self.callbackId];
    NSLog(@"jsString:%@", jsString);
    [request.delegate writeJavascript:jsString];
}

@end
