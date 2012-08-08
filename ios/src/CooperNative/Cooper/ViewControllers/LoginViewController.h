//
//  LoginViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CooperService/AccountService.h"
#import "LoginViewDelegate.h"
#import "CustomButton.h"
#ifdef __ALI_VERSION__
#import "DomainLabel.h"
#endif
#import "BaseViewController.h"
#import "GTMOAuth2Authentication.h"

@interface LoginViewController : BaseViewController<UITableViewDelegate
,UITableViewDataSource
,MBProgressHUDDelegate
,NetworkDelegate
#ifdef __ALI_VERSION__
,DomainLabelDelegate
#endif
>
{
    AccountRequestType requestType;
    MBProgressHUD *HUD;
    
    //google oauth2 client id and key
    NSString *googleClientId;
    NSString *googleClientSecret;
    
    GTMOAuth2Authentication *mAuth;
}

@property(nonatomic,assign) id<LoginViewDelegate> delegate;

@property (retain, nonatomic) UITextField *textUsername;
@property (retain, nonatomic) UITextField *textPassword;
@property (retain, nonatomic) UITableView *loginTableView;
@property (retain, nonatomic) CustomButton *btnLogin;
@property (retain, nonatomic) CustomButton *btnSkip;
@property (retain, nonatomic) CustomButton *btnGoogleLogin;
#ifdef __ALI_VERSION__
@property (retain, nonatomic) DomainLabel *domainLabel;
#endif

@property (nonatomic, retain) GTMOAuth2Authentication *auth;

@end
