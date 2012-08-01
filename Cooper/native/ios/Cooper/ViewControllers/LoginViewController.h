//
//  LoginViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "NetworkManager.h"
#import "AccountService.h"
#import "LoginViewDelegate.h"
#import "CustomButton.h"
#import "DomainLabel.h"
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate,NetworkDelegate,DomainLabelDelegate>
{
    MBProgressHUD *HUD;
}

@property(nonatomic,assign) id<LoginViewDelegate> delegate;

@property (retain, nonatomic) UITextField *textUsername;
@property (retain, nonatomic) UITextField *textPassword;
@property (retain, nonatomic) UITableView *loginTableView;
@property (retain, nonatomic) CustomButton *btnLogin;
#ifndef CODESHARP_VERSION
@property (retain, nonatomic) DomainLabel *domainLabel;
#endif

- (void)loginAction;

@end
