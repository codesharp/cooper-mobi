//
//  MainViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//


#import "LoginViewDelegate.h"
#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "TaskListViewController.h"
#import "TaskOptionViewController.h"
#import "LoginViewController.h"

@interface MainViewController : BaseViewController<LoginViewDelegate,UITabBarControllerDelegate>

@property (nonatomic, retain) BaseNavigationController *tasklistNavController;
@property (nonatomic, retain) BaseNavigationController *taskOptionNavController;
@property (nonatomic, retain) BaseNavigationController *loginViewNavController;

@end
