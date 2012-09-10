//
//  HttpWebRequest.h
//  CodesharpSDK
//
//  Created by sunleepy on 12-9-8.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "Reachability.h"

@protocol HttpWebRequestDelegate <NSObject>

- (void)networkNotReachable;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
- (void)addRequstToPool:(ASIHTTPRequest *)request;
- (void)queueFinished:(ASINetworkQueue *)queue;
- (void)notProcessReturned:(NSMutableDictionary*)context;

@end

@interface HttpWebRequest : NSObject

@property(nonatomic,assign) id<HttpWebRequestDelegate> delegate;

- (id)init;
- (ASIFormDataRequest*)createPostRequest:(NSString*)url
                                 params:(NSMutableDictionary*)params
                                headers:(NSMutableDictionary*)headers
                                context:(NSMutableDictionary*)context;
- (void)postAsync:(NSString*)url
           params:(NSMutableDictionary*)params
          headers:(NSMutableDictionary*)headers
          context:(NSMutableDictionary*)context
         Delegate:(id)myDelegate;
//- (void)postSync;
//- (void)getAsync;
//- (void)getSync;

@end
