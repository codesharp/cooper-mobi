//
//  MainViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "LoginViewDelegate.h"
#import "TasklistViewController.h"
#import "BaseViewController.h"
#import "BaseNavigationController.h"

@interface MainViewController : BaseViewController<LoginViewDelegate,UITabBarControllerDelegate>
{
    //是否可登录
    bool _launching;
}
@end
