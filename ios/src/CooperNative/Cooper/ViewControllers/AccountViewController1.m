//
//  AccountViewController.m
//  Cooper
//
//  Created by 磊 李 on 12-7-12.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountService.h"
@interface AccountViewController ()

@end

@implementation AccountViewController

@synthesize textUsername;
@synthesize textPassword;
@synthesize loginTableView;
@synthesize accountView;
#ifndef CODESHARP_VERSION
@synthesize domainLabel;
#endif

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"帐号设置", @"帐号设置");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    
    self.accountView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 80, 30)] autorelease];
    label.text = @"当前登录账户：%@";
    [self.accountView addSubview:label];
    
    self.loginTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
    [self.loginTableView setAllowsSelection:NO];
    self.loginTableView.scrollEnabled = NO;
    CGRect rect = self.loginTableView.frame;
    [self.loginTableView setFrame:CGRectMake(rect.origin.x, rect.origin.y + 400, rect.size.width, 120)];
    loginTableView.delegate = self;
    loginTableView.dataSource = self;
    
    
    [self.view addSubview:loginTableView];
}

- (void)goBack:(id)sender
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
    
#ifndef CODESHARP_VERSION
    [domainLabel release];
#endif
    [textUsername release];
    [textPassword release];
    [loginTableView release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#ifndef CODESHARP_VERSION
    return 3;
#else
    return 2;
#endif
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSInteger currentRow = indexPath.row;
    if(indexPath.section == 0)
    {
#ifndef CODESHARP_VERSION
        if(indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"DomainCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DomainCell"] autorelease];
                
                domainLabel = [[DomainLabel alloc] initWithFrame:CGRectMake(0, 0, 210, 30)];
                domainLabel.text = DEFAULT_DOMAIN;
                [domainLabel setBackgroundColor:[UIColor clearColor]];
                domainLabel.userInteractionEnabled = YES;
                UITapGestureRecognizer *recoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDomain)];
                [domainLabel addGestureRecognizer:recoginzer];
                domainLabel.delegate = self;
                [recoginzer release];
                
                cell.textLabel.text = @"域名";
                cell.accessoryView = domainLabel;
            }
        }
        else if(indexPath.row == 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"UsernameCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UsernameCell"] autorelease];
                
                CGFloat width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 660 : 285;
                self.textUsername = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 20)];  
                
                [self.textUsername setPlaceholder:@"用户名"]; 
                [self.textUsername setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                [self.textUsername setAutocorrectionType:UITextAutocorrectionTypeNo];
                [self.textUsername setReturnKeyType:UIReturnKeyDone];
                [self.textUsername addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
                cell.accessoryView = self.textUsername;
                
                
            }
        }
        else if(indexPath.row == 2)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PasswordCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PasswordCell"] autorelease];
                
                CGFloat width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 660 : 285;
                self.textPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 20)]; 
                [self.textPassword setSecureTextEntry:YES];
                [self.textPassword setPlaceholder:@"密码"];
                [self.textPassword setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                [self.textPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
                [self.textPassword setReturnKeyType:UIReturnKeyDone];
                [self.textPassword addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
                
                cell.accessoryView = self.textPassword;
            }
        }   
#else
        if(indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"UsernameCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UsernameCell"] autorelease];
                
                CGFloat width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 660 : 285;
                self.textUsername = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 20)];  
                
                [self.textUsername setPlaceholder:@"用户名"]; 
                [self.textUsername setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                [self.textUsername setAutocorrectionType:UITextAutocorrectionTypeNo];
                [self.textUsername setReturnKeyType:UIReturnKeyDone];
                [self.textUsername addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
                cell.accessoryView = self.textUsername;
                
                
            }
        }
        else if(indexPath.row == 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PasswordCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PasswordCell"] autorelease];
                
                CGFloat width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 660 : 285;
                self.textPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 20)]; 
                [self.textPassword setSecureTextEntry:YES];
                [self.textPassword setPlaceholder:@"密码"];
                [self.textPassword setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                [self.textPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
                [self.textPassword setReturnKeyType:UIReturnKeyDone];
                [self.textPassword addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
                
                cell.accessoryView = self.textPassword;
            }
        }
#endif
    }
    return cell;
}

- (void)tableViewCell:(SimplePickerInputTableViewCell *)cell didEndEditingWithValue:(NSString *)value {
	NSLog(@"%@ changed to: %@", cell.textLabel.text, value);
    cell.detailTextLabel.text = value;
}

#pragma mark - Table view delegate

- (BOOL)checkAccount:(NSString*)domain username:(NSString*)username password:(NSString*)password
{
    if([domain length] == 0 || [username length] == 0 || [password length] == 0)
    {
        return NO;
    }
    return YES;
}

#ifndef CODESHARP_VERSION
- (void)selectDomain
{
    [domainLabel becomeFirstResponder];
}
#endif

- (void)saveSetting:(id)sender
{
//    UITableView *tv = self.tableView;
//    UITableViewCell *cell1 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    UITableViewCell *cell2 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    UITableViewCell *cell3 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    
//    UITextField *textUsername = (UITextField*)cell2.accessoryView;
//    UITextField *textPassword = (UITextField*)cell3.accessoryView;
//    
//    NSString *domain = cell1.detailTextLabel.text;
//    NSString *username = textUsername.text;
//    NSString *password = textPassword.text;
//    
//    if (![self checkAccount:domain username:username password:password]) {
//        [Tools alert:@"域帐号／用户名／密码不可为空"];
//        return;
//    }
//    
//    HUD = [Tools process:@"正在登录" view:self.view];
//    
//    requestType = 0;
//    [AccountService logout:self];
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];  
}

-(void)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (void)addRequstToPool:(ASIHTTPRequest *)request {
    //    [requestPool addObject:request];
    NSLog(@"发送请求：%@",request.url);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    NSLog(@"response:%@, %d", [request responseString], [request responseStatusCode]);
//    
//    //TODO:...
//    if([request responseStatusCode] == 200 && [[request responseString] rangeOfString:@"loginSuccess"].length > 0)
//    {
//        if(requestType == 0)
//        {
//            requestType = 1;
//            
//            UITableView *tv = self.tableView;
//            UITableViewCell *cell1 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            UITableViewCell *cell2 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//            UITableViewCell *cell3 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//            
//            UITextField *textUsername = (UITextField*)cell2.accessoryView;
//            UITextField *textPassword = (UITextField*)cell3.accessoryView;
//            
//            NSString *domain = cell1.detailTextLabel.text;
//            NSString *username = textUsername.text;
//            NSString *password = textPassword.text;
//            
//            if (![self checkAccount:domain username:username password:password]) {
//                [Tools alert:@"域帐号／用户名／密码不可为空"];
//                return;
//            }
//            
//            [[Constant instance] setDomain:domain];
//            [[Constant instance] setUsername:username];
//            //[[Constant instance] setPassword:password];
//            
//            [Constant saveToCache];
//            
//            [AccountService login:domain username:username password:password delegate:self];
//        }
//        else
//            [Tools msg:@"登录成功" HUD:HUD];     
//    }
//    else{
//        [Tools msg:@"登录失败" HUD:HUD];
//    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request error %@",request.error);
    [Tools failed:HUD];
}

@end
