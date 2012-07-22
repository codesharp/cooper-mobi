//
//  TaskService.h
//  CooperGap
//
//  Created by sunleepy on 12-7-20.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif

@interface TaskService : CDVPlugin

@property (nonatomic, copy) NSString* callbackId;

- (void) getTasks:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
