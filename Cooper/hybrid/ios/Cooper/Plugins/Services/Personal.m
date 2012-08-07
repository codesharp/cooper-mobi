//
//  Personal.m
//  Cooper
//
//  Created by sunleepy on 12-8-7.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "Personal.h"

@implementation Personal

@synthesize callbackId;

- (void)getbypriority:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    self.callbackId = [arguments objectAtIndex:0];
    
    NSString* tasklistId = [options valueForKey:@"tasklistId"];
    
    //NSMutableDictionary *data = [NSMutableDictionary dictionary];
    //[data setObject:tasklistId forKey:@"tasklistId"];
    
    NSString *url = [[[Constant instance] path] stringByAppendingFormat:TASK_GETBYPRIORITY_URL];
    NSLog(@"获取按优先级任务数据URL:%@", url);
    
    [NetworkManager doAsynchronousPostRequest:url Delegate:self data:options WithInfo:nil addHeaders:nil];
}

- (void)createtasklist:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    self.callbackId = [arguments objectAtIndex:0];
    
    NSString* name = [options valueForKey:@"name"];
    NSString* type = [options valueForKey:@"type"];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:name forKey:@"name"];
    [data setObject:type forKey:@"type"];
    
    NSString *url = [[[Constant instance] path] stringByAppendingFormat:CREATETASKLIST_URL];
    [NetworkManager doAsynchronousPostRequest:url Delegate:self data:data WithInfo:nil addHeaders:nil];
}

- (void)gettasklists:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    self.callbackId = [arguments objectAtIndex:0];
    
    NSString *url = [[[Constant instance] path] stringByAppendingFormat:GETTASKLISTS_URL];
    NSLog(@"getTasklists外部路径: %@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:self data:nil WithInfo:nil addHeaders:nil];
}

- (void)sync:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{ 
    NSString *url = [[[Constant instance] path] stringByAppendingFormat:TASK_SYNC_URL];
    NSLog(@"同步数据路径:%@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:self data:options WithInfo:nil addHeaders:nil];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"response data: %@, %d", [request responseString], [request responseStatusCode]);

    NSString *jsString = nil;
    
    if([request.url.absoluteString rangeOfString: TASK_SYNC_URL].length > 0)
    {
        if([request responseStatusCode] == 200)
        {
            NSMutableDictionary *jsonDict = [[request responseString] JSONValue];
            
            CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: jsonDict];
            
            jsString = [result toSuccessCallbackString:self.callbackId];
        }
        else {
            CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:@"error"];
            jsString = [result toErrorCallbackString:self.callbackId];
        }
    }
    else if([request.url.absoluteString rangeOfString: TASK_GETBYPRIORITY_URL].length > 0)
    {
        if([request responseStatusCode] == 200)
        {
            NSMutableDictionary *jsonDict = [[request responseString] JSONValue];
            
            CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: jsonDict];
            
            jsString = [result toSuccessCallbackString:self.callbackId];
        }
        else {
            CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:@"error"];
            jsString = [result toErrorCallbackString:self.callbackId];
        }
    }
    else if([request.url.absoluteString rangeOfString: CREATETASKLIST_URL].length > 0)
    {
        if([request responseStatusCode] == 200)
        {
            NSString *responseString = [request responseString];
            
            CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsInt: [responseString intValue]];
            
            jsString = [result toSuccessCallbackString:self.callbackId];
        }
        else {
            CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:@"error"];
            jsString = [result toErrorCallbackString:self.callbackId];
        }
    }
    else if([request.url.absoluteString rangeOfString: GETTASKLISTS_URL].length > 0)
    {
        if([request responseStatusCode] == 200)
        {
            //NSString *responseString = [request responseString];
            
            NSMutableDictionary *jsonDict = [[request responseString] JSONValue];
            
            CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: jsonDict];
            
            jsString = [result toSuccessCallbackString:self.callbackId];
        }
        else {
            CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:@"error"];
            jsString = [result toErrorCallbackString:self.callbackId];
        }
    }
    [request.delegate writeJavascript:jsString];
    //self.callbackId = nil;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request error: %@", request.error);
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"failed"];
    NSString *jsString = [result toSuccessCallbackString:self.callbackId];
    NSLog(@"jsString:%@", jsString);
    [request.delegate writeJavascript:jsString];
}

- (void)addRequstToPool:(ASIHTTPRequest *)request {
    //    [requestPool addObject:request];
    NSLog(@"发送请求：%@",request.url);
}

@end
