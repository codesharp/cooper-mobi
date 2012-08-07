//
//  HttpRequest.h
//  CooperGap
//
//  Created by 磊 李 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"

#define SYSTEM_REQUEST_TIMEOUT 30.0f

@interface HttpRequest : CDVPlugin

@property (nonatomic, copy) NSString* callbackId;

- (void) get:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) post:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
