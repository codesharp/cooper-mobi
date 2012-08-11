//
//  NetworkManager.h
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"

@protocol NetworkDelegate;

@interface NetworkManager : NSObject  {
	id<NetworkDelegate> _delegate;
}

@property(nonatomic,assign) id<NetworkDelegate> delegate;

+ (BOOL)isOnline;
//get method
+ (ASIHTTPRequest *)getRequest:(NSString *)url;
//post method
+ (ASIFormDataRequest*)getPostRequest:(NSString*)url;
+ (ASIHTTPRequest *)doAsynchronousGetRequest:(NSString *)url Delegate:(id)delegate WithInfo:(NSDictionary *)info;
+ (NSString *)doSynchronousRequest:(NSString *)url data:(NSMutableDictionary*)data;
+ (NSString *)doSynchronousPostRequest:(NSString *)url 
                                  data:(NSMutableDictionary*)data;

+ (ASIFormDataRequest*)doAsynchronousPostRequest:(NSString *)url Delegate:(id)delegate data:(NSMutableDictionary*)data WithInfo:(NSDictionary *)info addHeaders:(NSMutableDictionary*)headers;
@end


@protocol NetworkDelegate

- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;

@required
- (void)addRequstToPool:(ASIHTTPRequest *)request;

@end
