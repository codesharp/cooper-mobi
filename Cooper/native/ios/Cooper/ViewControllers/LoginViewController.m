//
//  LoginViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "LoginViewController.h"
#import "TaskViewController.h"

@implementation LoginViewController
@synthesize textUsername;
@synthesize textPassword;
@synthesize loginTableView;
@synthesize delegate;
@synthesize btnLogin;
#ifndef CODESHARP_VERSION
@synthesize domainLabel;
#endif

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loginTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
    [self.loginTableView setAllowsSelection:NO];
    CGRect rect = self.loginTableView.frame;
    [self.loginTableView setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 120)];
    loginTableView.delegate = self;
    loginTableView.dataSource = self;
    
    btnLogin = [[CustomButton alloc] initWithFrame:CGRectMake(240, 230, 70, 40) image:[UIImage imageNamed:@"btn_center.png"]];
    btnLogin.layer.cornerRadius = 6.0f;
    [btnLogin.layer setMasksToBounds:YES];
    [btnLogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [btnLogin setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:btnLogin];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
#ifndef CODESHARP_VERSION
    [domainLabel release];
#endif
    [textUsername release];
    [textPassword release];
    [loginTableView release];
    [btnLogin release];
    [super dealloc];
}

- (void)login 
{
#ifndef CODESHARP_VERSION
    if ([domainLabel.text length] > 0 
        && [textUsername.text length] > 0
        && [textPassword.text length] > 0) 
#else
      if([textUsername.text length] > 0
         && [textPassword.text length] > 0)
#endif
    {
        HUD = [Tools process:@"登录中" view:self.view];
        
#ifndef CODESHARP_VERSION
        [AccountService login:domainLabel.text 
                     username:textUsername.text 
                     password:textPassword.text 
                     delegate:self];
#else
        [AccountService login:textUsername.text
                     password:textPassword.text
                     delegate:self];
#endif
    }
    else 
    {
        [Tools alert:@"请输入用户名和密码"];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [Tools close:HUD];
    //TODO:暂时采用字符串包含来判断是否登录成功
    NSLog(@"请求响应数据: %@, %d", [request responseString], [request responseStatusCode]);
    if([request responseStatusCode] == 200)
    {
        NSArray* array = [request responseCookies];
        NSLog(@"array:%d",  array.count);

        NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:array];
        NSHTTPCookie *cookieA = [NSHTTPCookie cookieWithProperties:dict];
        NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
        [sharedHTTPCookie setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        [sharedHTTPCookie setCookie:cookieA];
        
        //NSLog(@"请求响应数据: %@", request.responseString);
#ifndef CODESHARP_VERSION
        [[Constant instance] setDomain:domainLabel.text];
#endif
        [[Constant instance] setUsername:textUsername.text];
        //TODO:自动保存用户登录
        [[Constant instance] setIsSaveUser:YES];
        [self dismissModalViewControllerAnimated:NO];
        [Constant saveToCache];
        [delegate loginExit]; 
    }
    else if([request responseStatusCode] == 400)
    {
        [Tools alert:[request responseString]];
    }
    else
    {
        [Tools alert:@"未知异常"];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //[self removeRequstFromPool:request];
    [Tools failed:HUD];
    NSLog(@"请求异常: %@",request.error);
}
- (void)addRequstToPool:(ASIHTTPRequest *)request
{
//    [requestPool addObject:request];
    NSLog(@"发送请求路径：%@",request.url);
}

-(IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

# pragma mark login table view

//获取TableView的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//获取在制定的分区编号下的纪录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#ifndef CODESHARP_VERSION
    return 3;
#else
    return 2;
#endif
}
//填充单元格
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

#ifndef CODESHARP_VERSION
- (void)selectDomain
{
    [domainLabel becomeFirstResponder];
}
#endif

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}

@end
