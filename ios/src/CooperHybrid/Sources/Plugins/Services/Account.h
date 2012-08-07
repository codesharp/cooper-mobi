//
//  Account.h
//  Cooper
//
//  Created by sunleepy on 12-8-7.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"

@interface Account : CDVPlugin

@property (nonatomic, copy) NSString* callbackId;

- (void) login:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
