//
//  LoginViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import "LoginViewController.h"
#import "TaskViewController.h"
#import "SecondViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize textDomain;
@synthesize textUsername;
@synthesize textPassword;
@synthesize checkView;
@synthesize btnSaveAccount;
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    checkView.center = CGPointMake(9, btnSaveAccount.frame.size.height/2);
    
    [btnSaveAccount addSubview:checkView];

    if ([[Constant instance] isSaveUser]) {
        
        checkView.image = [UIImage imageNamed:@"check.png"];
        if (1 < [[[Constant instance] domain] length]) {
            textDomain.text = [[Constant instance] domain];
        }
        else {
            textDomain.text = DEFAULT_DOMAIN;
        }
        textUsername.text = [[Constant instance] username];
    }
    else {
        checkView.image = [UIImage imageNamed:@"uncheck.png"];
        textDomain.text = DEFAULT_DOMAIN;
        textUsername.text = @"";
    }
    textPassword.text = @"";
    
    if (1 < [[[Constant instance] domain] length]
        && 1 < [[[Constant instance] username] length]
        && 1 < [[[Constant instance] password] length]
        && [[Constant instance] isSaveUser] == YES) {
        
        textDomain.text = [[Constant instance] domain];
        textUsername.text = [[Constant instance] username];
        textPassword.text = [[Constant instance] password];
        [self loginAction];      
    }
}

- (void)viewDidUnload
{
    [self setTextDomain:nil];
    [self setTextUsername:nil];
    [self setTextPassword:nil];
    [self setBtnSaveAccount:nil];
    [self setCheckView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    viewCenter = self.view.center;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardWillShowNotification
//                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardWillHideNotification
//                                                  object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [textDomain release];
    [textUsername release];
    [textPassword release];
    [btnSaveAccount release];
    [checkView release];
    [super dealloc];
}
- (IBAction)saveAccountAction {
    if ([[Constant instance] isSaveUser]) {
        [[Constant instance] setIsSaveUser:NO];
        checkView.image = [UIImage imageNamed:@"uncheck.png"];
    }
    else {
        [[Constant instance] setIsSaveUser:YES];
        checkView.image = [UIImage imageNamed:@"check.png"];
    }
NSLog(@"isSaveUser:%d", [[Constant instance] isSaveUser]);
}

- (IBAction)loginAction {
    if (0 < [textDomain.text length]
        && 0 < [textUsername.text length]
        && 0 < [textPassword.text length]) {
        NSLog(@"btn action");
        [self addHUD:@"登录中"];
        
        [AccountService arkLogin:textDomain.text username:textUsername.text password:textPassword.text delegate:self];
    }
    else {
        [Tools alert:@"输入不全"];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    [self HUDCompleted];
    
    if([request responseStatusCode] == 200)
    {
        NSLog(@"response string:%@", request.responseString);
        [[Constant instance] setDomain:textDomain.text];
        [[Constant instance] setUsername:textUsername.text];
        //[[Constant instance] setPassword:textPassword.text];              
        [self dismissModalViewControllerAnimated:NO];          
        
        [Constant saveToCache];
        
        [delegate loginExit];
    }
    else
    {
        [Tools alert:@"用户名或密码错误"];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    //[self removeRequstFromPool:request];
    [self HUDFailed];
    NSLog(@"request error %@",request.error);
}
- (void)addRequstToPool:(ASIHTTPRequest *)request {
//    [requestPool addObject:request];
    NSLog(@"发送请求：%@",request.url);
}

- (void)HUDCompleted{
    [HUD hide:YES];
}


- (void)HUDFailed{
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.labelText = @"请求失败";
    HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:0.3];
}

- (void)checkRequestError:(NSDictionary *)dic {
    if (0 == [[dic allKeys] count]) 
        [self showAlertWithTitle:@"请确定不是通过连接xxx上网"];
    else if ([[dic allKeys] containsObject:@"Message"])
        [self showAlertWithTitle:[NSString stringWithFormat:@"服务器故障%@",[dic objectForKey:@"ErrorCode"]]];
    else 
        [self showAlertWithTitle:@"未知错误"];
}

- (void)keyboardWillShow:(NSNotification *)aNotification 
{
    //[self.view removeFromSuperview];
	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration =
	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    CGPoint center = viewCenter;
    center.y -= keyboardRect.size.height;
    center.y += 100.0f;
    self.view.center = center;
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //[regionView removeFromSuperview];
    NSTimeInterval animationDuration =
	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    self.view.center = viewCenter;
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

- (void)addHUD:(NSString *)text{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([text length]) {
        HUD.labelText = text;
    }
}

-(IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (void)showAlertWithTitle:(NSString *)title {
    [[[UIAlertView alloc] initWithTitle:title
                                message:nil  
                               delegate:nil 
                      cancelButtonTitle:@"取消" 
                      otherButtonTitles:nil] show];
}

@end
