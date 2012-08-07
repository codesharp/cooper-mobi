//
//  Account.m
//  Cooper
//
//  Created by sunleepy on 12-8-7.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "Account.h"

@implementation Account

@synthesize callbackId;

- (void)login:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    self.callbackId = [arguments objectAtIndex:0];
    
    NSString* userName = [options valueForKey:@"userName"];
    NSString* password = [options valueForKey:@"password"];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:userName forKey:@"userName"];
    [data setObject:password forKey:@"password"];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers setObject:@"xmlhttp" forKey:@"X-Requested-With"];
    
    NSString* url = [[[Constant instance] path] stringByAppendingFormat:LOGIN_URL];
    NSLog(@"正在进行登录请求: %@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:self data:data WithInfo:nil addHeaders:headers];
}

- (void)addRequstToPool:(ASIHTTPRequest *)request {
    //    [requestPool addObject:request];
    NSLog(@"发送请求：%@",request.url);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"response data: %@, %d", [request responseString], [request responseStatusCode]);
//    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"ok"];
//    //CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: dictionary];
//    NSString *jsString = [result toSuccessCallbackString:self.callbackId];
//    NSLog(@"jsString:%@", jsString);
//    [request.delegate writeJavascript:jsString];
    NSString *jsString = nil;
    if([request responseStatusCode] == 200)
    {
        NSString *responseString = [request responseString];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:responseString];
        jsString = [result toSuccessCallbackString:self.callbackId];
    }
    else {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:@"error"];
        jsString = [result toErrorCallbackString:self.callbackId];
    }
    
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
