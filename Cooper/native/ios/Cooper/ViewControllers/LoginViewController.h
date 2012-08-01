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
#ifdef __ALI_VERSION__
#import "DomainLabel.h"
#endif
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UITableViewDelegate
    ,UITableViewDataSource
    ,MBProgressHUDDelegate
    ,NetworkDelegate
#ifdef __ALI_VERSION__
    ,DomainLabelDelegate
#endif
>
{
    MBProgressHUD *HUD;
}

@property(nonatomic,assign) id<LoginViewDelegate> delegate;

@property (retain, nonatomic) UITextField *textUsername;
@property (retain, nonatomic) UITextField *textPassword;
@property (retain, nonatomic) UITableView *loginTableView;
@property (retain, nonatomic) CustomButton *btnLogin;
@property (retain, nonatomic) CustomButton *btnSkip;
#ifdef __ALI_VERSION__
@property (retain, nonatomic) DomainLabel *domainLabel;
#endif

- (void)loginAction;

@end
