//
//  HttpRequest.m
//  CooperGap
//
//  Created by 磊 李 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest

@synthesize callbackId;

- (void)get:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString* url = [options valueForKey:@"url"];
    NSLog(@"get request url: %@", url);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	[hostReach startNotifier];
	if (NotReachable == [hostReach currentReachabilityStatus]) {
		[[[UIAlertView alloc] initWithTitle:@"" message:@"网络不可用" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
        return;
	}
    
	if (nil == request) {
		[self requestFailed:nil];
		return;
	}
//	if (nil != info) {
//		[request setUserInfo:[NSDictionary dictionaryWithDictionary:info]];
//	}
    
    [request setValidatesSecureCertificate:NO];
    [request setTimeOutSeconds:SYSTEM_REQUEST_TIMEOUT];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	
	[request setDelegate:self];
	[request startAsynchronous];
}

- (void)post:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    self.callbackId = [arguments objectAtIndex:0];
    
    NSString* url = [arguments objectAtIndex:1];
    //NSString* url = [options valueForKey:@"url"];
    NSLog(@"post request url: %@", url);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	[hostReach startNotifier];
	if (NotReachable == [hostReach currentReachabilityStatus]) {
		[[[UIAlertView alloc] initWithTitle:@"" message:@"网络不可用" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
        return nil;
	}
    
    if (nil == request) {
		[self requestFailed:nil];
		return nil;
	}
//	if (nil != info) {
//		[request setUserInfo:[NSDictionary dictionaryWithDictionary:info]];
//	}
    
    [request setTimeOutSeconds:SYSTEM_REQUEST_TIMEOUT];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
    
    if(options)
    {
        for(NSString *key in options.allKeys)
        {
            if([key isEqualToString:@"url"])
                continue;
            [request setPostValue:[options objectForKey:key] forKey:key];
        }
    }
    
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:self];
	[request startAsynchronous];
}

- (void)addRequstToPool:(ASIHTTPRequest *)request {
    //    [requestPool addObject:request];
    NSLog(@"发送请求：%@",request.url);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"response data: %@, %d", [request responseString], [request responseStatusCode]);
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"ok"];
    //CDVPluginResult *result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary: dictionary];
    NSString *jsString = [result toSuccessCallbackString:self.callbackId];
    NSLog(@"jsString:%@", jsString);
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
