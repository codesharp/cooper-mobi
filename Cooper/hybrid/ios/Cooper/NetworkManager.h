//
//  NetworkManager.h
//  Cooper
//
//  Created by Ping Li on 12-7-4.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"

#define SYSTEM_REQUEST_TIMEOUT 30.0f

@protocol NetworkDelegate;

@interface NetworkManager : NSObject  {
	id<NetworkDelegate> _delegate;
}

@property(nonatomic,assign) id<NetworkDelegate> delegate;

//get method
+ (ASIHTTPRequest *)getRequest:(NSString *)url;
//post method
+ (ASIFormDataRequest*)getPostRequest:(NSString*)url;
+ (ASIHTTPRequest *)doAsynchronousGetRequest:(NSString *)url Delegate:(id)delegate WithInfo:(NSDictionary *)info;
+ (NSString *)doSynchronousRequest:(NSString *)url;

+ (ASIFormDataRequest*)doAsynchronousPostRequest:(NSString *)url Delegate:(id)delegate data:(NSMutableDictionary*)data WithInfo:(NSDictionary *)info;
@end


@protocol NetworkDelegate

- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;

@required
- (void)addRequstToPool:(ASIHTTPRequest *)request;

@end
