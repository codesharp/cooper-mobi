//
//  TaskListViewController.h
//  CooperGap
//
//  Created by sunleepy on 12-7-18.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVViewController.h>
#else
#import "CDVViewController.h"
#endif

#import "CooperCDVViewController.h"

@interface TaskListViewController : CooperCDVViewController
- (id)initWithTitle:(NSString*)title setImage:(NSString*)imageName;
@end
