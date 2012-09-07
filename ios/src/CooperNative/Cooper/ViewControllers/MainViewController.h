//
//  MainViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//


#import "LoginViewDelegate.h"
#import "BaseViewController.h"
#import "TaskListViewController.h"
#import "LoginViewController.h"

@interface MainViewController : BaseViewController<LoginViewDelegate,UITabBarControllerDelegate>

@property (nonatomic, retain) TasklistViewController *tasklistViewController;
@property (nonatomic, retain) LoginViewController *loginViewController;
@end
