//
//  NetworkManager.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

@synthesize delegate;


+ (ASIHTTPRequest *)getRequest:(NSString *)url {
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	[hostReach startNotifier];
	if (NotReachable == [hostReach currentReachabilityStatus]) {
		[[[UIAlertView alloc] initWithTitle:@"" message:@"网络不可用" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
        return nil;
	}
    
	return request;
}

+ (ASIFormDataRequest*)getPostRequest:(NSString*)url
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	[hostReach startNotifier];
	if (NotReachable == [hostReach currentReachabilityStatus]) {
		[[[UIAlertView alloc] initWithTitle:@"" message:@"网络不可用" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
        return nil;
	}
    
    return request;
}

+ (ASIHTTPRequest *)doAsynchronousGetRequest:(NSString *)url Delegate:(id)delegate WithInfo:(NSDictionary *)info {
	ASIHTTPRequest *request = [self getRequest:url];
	if (nil == request) {
		[delegate requestFailed:nil];
		return nil;
	}
	if (nil != info) {
		[request setUserInfo:[NSDictionary dictionaryWithDictionary:info]];
	}
    
    [request setValidatesSecureCertificate:NO];
    [request setTimeOutSeconds:SYSTEM_REQUEST_TIMEOUT];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	
	[request setDelegate:delegate];
	[request startAsynchronous];
    
    [delegate addRequstToPool:request];
	
	return request;
}

+ (NSString *)doSynchronousRequest:(NSString *)url {
	ASIHTTPRequest *request = [self getRequest:url];
	if (nil == request) {
		return nil;
	}
    
	[request startSynchronous];
	NSError *error = [request error];
	if (!error) {
		return [request responseString];
	}
	return nil;
}

+ (ASIFormDataRequest *)doAsynchronousPostRequest:(NSString*)url Delegate:(id)delegate data:(NSMutableDictionary*)data WithInfo:(NSDictionary*)info
{
    ASIFormDataRequest *request = [self getPostRequest:url];
    if (nil == request) {
		[delegate requestFailed:nil];
		return nil;
	}
	if (nil != info) {
		[request setUserInfo:[NSDictionary dictionaryWithDictionary:info]];
	}
    
    [request setTimeOutSeconds:SYSTEM_REQUEST_TIMEOUT];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy];

    if(data)
    {
        for(NSString *key in data.allKeys)
            [request setPostValue:[data objectForKey:key] forKey:key];
    }
    
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:delegate];
	[request startAsynchronous];
    
    [delegate addRequstToPool:request];
    
    return request;
}

@end
