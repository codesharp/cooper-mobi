//
//  AccountViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-30.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"
#import "AccountService.h"
#import "CustomButton.h"
#import "DomainLabel.h"

@interface AccountViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,DomainLabelDelegate>
{
    MBProgressHUD *HUD;
    
    int requestType;
}

@property (retain, nonatomic) UITextField *textUsername;
@property (retain, nonatomic) UITextField *textPassword;
@property (retain, nonatomic) UITableView *loginTableView;
@property (retain, nonatomic) UIView *accountView;
@property (retain, nonatomic) CustomButton *btnLogin;
#ifndef CODESHARP_VERSION
@property (retain, nonatomic) DomainLabel *domainLabel;
#endif

- (void)loginAction;
@end
