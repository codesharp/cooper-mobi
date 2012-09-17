//
//  HttpWebRequest.m
//  CodesharpSDK
//
//  Created by sunleepy on 12-9-8.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "HttpWebRequest.h"

@implementation HttpWebRequest

@synthesize delegate;

- (id)init
{
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (ASIFormDataRequest*)createPostRequest:(NSString*)url
                                 params:(NSMutableDictionary*)params
                                headers:(NSMutableDictionary*)headers
                                context:(NSMutableDictionary*)context
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
	[reachability startNotifier];
	if (reachability.currentReachabilityStatus == NotReachable) {
        return nil;
	}
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    if (context)
    {
		[request setUserInfo:[NSDictionary dictionaryWithDictionary:context]];
	}
    if (headers)
    {
        for (NSString *key in headers.allKeys)
        {
            [request addRequestHeader:key value:[headers objectForKey:key]];
        }
    }
    if(params)
    {
        for(NSString *key in params.allKeys)
        {
            [request setPostValue:[params objectForKey:key] forKey:key];
        }
    }
    
    //cookies设置
    NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //[request setUseCookiePersistence:YES];
    [request setRequestCookies: [NSMutableArray arrayWithArray:sharedHTTPCookie.cookies]];
    
    [request setTimeOutSeconds:SYSTEM_REQUEST_TIMEOUT];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
    
    [request setValidatesSecureCertificate:NO];
    return request;
}

- (ASIHTTPRequest*)createGetRequest:(NSString*)url
                                  params:(NSMutableDictionary*)params
                                 headers:(NSMutableDictionary*)headers
                                 context:(NSMutableDictionary*)context
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
	[reachability startNotifier];
	if (reachability.currentReachabilityStatus == NotReachable) {
        return nil;
	}
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    if (context)
    {
		[request setUserInfo:[NSDictionary dictionaryWithDictionary:context]];
	}
    if (headers)
    {
        for (NSString *key in headers.allKeys)
        {
            [request addRequestHeader:key value:[headers objectForKey:key]];
        }
    }
    if(params)
    {
        for(NSString *key in params.allKeys)
        {
            [request setPostValue:[params objectForKey:key] forKey:key];
        }
    }
    
    //cookies设置
    NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //[request setUseCookiePersistence:YES];
    [request setRequestCookies: [NSMutableArray arrayWithArray:sharedHTTPCookie.cookies]];
    
    [request setTimeOutSeconds:SYSTEM_REQUEST_TIMEOUT];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
    
    [request setValidatesSecureCertificate:NO];
    return request;
}

- (void)postAsync:(NSString *)url
           params:(NSMutableDictionary *)params
          headers:(NSMutableDictionary *)headers
          context:(NSMutableDictionary *)context
         delegate:(id)myDelegate
{
    self.delegate = myDelegate;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
	[reachability startNotifier];
	if (reachability.currentReachabilityStatus == NotReachable) {
		[self.delegate networkNotReachable];
        return;
	}
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    if (context)
    {
		[request setUserInfo:[NSDictionary dictionaryWithDictionary:context]];
	}
    if (headers)
    {
        for (NSString *key in headers.allKeys)
        {
            [request addRequestHeader:key value:[headers objectForKey:key]];
        }
    }
    if(params)
    {
        for(NSString *key in params.allKeys)
        {
            [request setPostValue:[params objectForKey:key] forKey:key];
        }
    }
    
    //cookies设置
    NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //[request setUseCookiePersistence:YES];
    [request setRequestCookies: [NSMutableArray arrayWithArray:sharedHTTPCookie.cookies]];
    
    [request setTimeOutSeconds:SYSTEM_REQUEST_TIMEOUT];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy];

    [request setValidatesSecureCertificate:NO];
    [request setDelegate:self.delegate];
	[request startAsynchronous];
    
    [self.delegate addRequstToPool:request];
}

- (void)getAsync:(NSString *)url
           params:(NSMutableDictionary *)params
          headers:(NSMutableDictionary *)headers
          context:(NSMutableDictionary *)context
         delegate:(id)myDelegate
{
    self.delegate = myDelegate;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
	[reachability startNotifier];
	if (reachability.currentReachabilityStatus == NotReachable) {
		[self.delegate networkNotReachable];
        return;
	}
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    if (context)
    {
		[request setUserInfo:[NSDictionary dictionaryWithDictionary:context]];
	}
    if (headers)
    {
        for (NSString *key in headers.allKeys)
        {
            [request addRequestHeader:key value:[headers objectForKey:key]];
        }
    }
    if(params)
    {
        for(NSString *key in params.allKeys)
        {
            [request setPostValue:[params objectForKey:key] forKey:key];
        }
    }
    
    //cookies设置
    NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //[request setUseCookiePersistence:YES];
    [request setRequestCookies: [NSMutableArray arrayWithArray:sharedHTTPCookie.cookies]];
    
    [request setTimeOutSeconds:SYSTEM_REQUEST_TIMEOUT];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
    
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:self.delegate];
	[request startAsynchronous];
    
    [self.delegate addRequstToPool:request];
}

@end
