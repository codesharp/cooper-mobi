//
//  LoginViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "AccountService.h"
#import "LoginViewDelegate.h"

@interface LoginViewController : UIViewController<UITableViewDelegate, MBProgressHUDDelegate,NetworkDelegate>
{
    CGPoint viewCenter;
    MBProgressHUD *HUD;
}

@property(nonatomic,assign) id<LoginViewDelegate> delegate;

@property (retain, nonatomic) IBOutlet UITextField *textDomain;
@property (retain, nonatomic) IBOutlet UITextField *textUsername;
@property (retain, nonatomic) IBOutlet UITextField *textPassword;
@property (retain, nonatomic) IBOutlet UIImageView *checkView;
@property (retain, nonatomic) IBOutlet UIButton *btnSaveAccount;
- (IBAction)saveAccountAction;
- (IBAction)loginAction;

@end
