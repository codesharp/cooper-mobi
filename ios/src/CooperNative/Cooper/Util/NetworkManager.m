//
//  NetworkManager.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

@synthesize delegate;


+ (ASIHTTPRequest *)getRequest:(NSString *)url {
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];
	[hostReach startNotifier];
	if (NotReachable == [hostReach currentReachabilityStatus]) {
        //[Tools alert:NOT_NETWORK_MESSAGE];
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
		//[Tools alert:NOT_NETWORK_MESSAGE];
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
    
//    NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    if(sharedHTTPCookie.cookies != nil)
//        [request setRequestCookies:[NSMutableArray arrayWithObject:sharedHTTPCookie.cookies]];
    [request setValidatesSecureCertificate:NO];
    [request setTimeOutSeconds:SYSTEM_REQUEST_TIMEOUT];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
	
	[request setDelegate:delegate];
	[request startAsynchronous];
    
    [delegate addRequstToPool:request];
	
	return request;
}

+ (NSString *)doSynchronousRequest:(NSString *)url 
                              data:(NSMutableDictionary*)data 
{
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

+ (NSString *)doSynchronousPostRequest:(NSString *)url 
                              data:(NSMutableDictionary*)data 
{
	ASIFormDataRequest *request = [self getPostRequest:url];
    
    if (nil == request) {
		return nil;
	}
    
    NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //[request setUseCookiePersistence:YES];
    
    [request setRequestCookies: [NSMutableArray arrayWithArray:sharedHTTPCookie.cookies]];
    
    if(data)
    {
        for(NSString *key in data.allKeys)
            [request setPostValue:[data objectForKey:key] forKey:key];
    }
    
	[request startSynchronous];
	NSError *error = [request error];
	if (!error) {
		return [request responseString];
	}
	return nil;
}

+ (ASIFormDataRequest *)doAsynchronousPostRequest:(NSString*)url 
                                         Delegate:(id)delegate 
                                             data:(NSMutableDictionary*)data 
                                         WithInfo:(NSDictionary*)info 
                                       addHeaders:(NSMutableDictionary*)headers
{
    ASIFormDataRequest *request = [self getPostRequest:url];
    if (nil == request) {
		[delegate requestFailed:nil];
		return nil;
	}
	if (nil != info) {
		[request setUserInfo:[NSDictionary dictionaryWithDictionary:info]];
	}
    
    NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //[request setUseCookiePersistence:YES];
    
    [request setRequestCookies: [NSMutableArray arrayWithArray:sharedHTTPCookie.cookies]];
        
    [request setTimeOutSeconds:SYSTEM_REQUEST_TIMEOUT];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy];

    if(data)
    {
        for(NSString *key in data.allKeys)
            [request setPostValue:[data objectForKey:key] forKey:key];
    }
    
    if(headers)
    {
        for (NSString *key in headers.allKeys) {
            [request addRequestHeader:key value:[headers objectForKey:key]];
        }
    }
    
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:delegate];
	[request startAsynchronous];
    
    [delegate addRequstToPool:request];
    
    return request;
}

@end
