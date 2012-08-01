//
//  MainViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//


#import "LoginViewDelegate.h"
#import "BaseViewController.h"

@interface MainViewController : BaseViewController<LoginViewDelegate,UITabBarControllerDelegate>
{
    //是否可登录
    bool _launching;
}
@end
