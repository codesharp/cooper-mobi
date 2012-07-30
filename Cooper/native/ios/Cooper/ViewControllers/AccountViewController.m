//
//  AccountViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-30.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "AccountViewController.h"
#import "AppDelegate.h"
#import "TasklistService.h"
#import "TasklistDao.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

@synthesize textUsername;
@synthesize textPassword;
@synthesize loginTableView;
@synthesize accountView;
@synthesize btnLogin;
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

- (void)loadView
{
    
//    self.loginTableView = [[[UITableView alloc] init] autorelease];
//    self.loginTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
//    [self.loginTableView setAllowsSelection:NO];
//    CGRect rect = self.loginTableView.frame;
//    [self.loginTableView setFrame:rect];
//    loginTableView.delegate = self;
//    loginTableView.dataSource = self;
//    
//    [self.view addSubview:loginTableView];
//    
//    [super loadView];
    

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    contentView.autoresizesSubviews = YES;
    contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    //contentView.backgroundColor = [UIColor clearColor];
    
    [self setView:contentView];
    [contentView release];
    
    CGRect rect = self.view.frame;
    
    if([[[Constant instance] username] length] > 0)
    {
        accountView = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 50)];
        
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 30)] autorelease];
        label.text = @"当前登录账户：";
        label.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        label.backgroundColor = [UIColor clearColor];
        
        UILabel *accountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(130, 10, 190, 30)] autorelease];
        accountLabel.text = [[Constant instance] username];
        accountLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        accountLabel.backgroundColor = [UIColor clearColor];
        
        [accountView addSubview:label];
        [accountView addSubview:accountLabel];
        
        [self.view addSubview:accountView];
    }
    else
    {
    loginTableView = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + 100, rect.size.width, rect.size.height) style:UITableViewStyleGrouped];
    [loginTableView setAutoresizesSubviews:YES];
    [loginTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    loginTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
    [loginTableView setDataSource:self];
    [loginTableView setDelegate:self];
    
    [[self view] addSubview:loginTableView];
    }
}

- (void)goBack:(id)sender
{
    if([[[Constant instance] username] length] == 0)
    {
        [Tools alert:@"请先重新设置账号登录"];
        return;
    }
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated:NO];
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
    
    CustomButton *saveTaskBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(5,5,50,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
    saveTaskBtn.layer.cornerRadius = 6.0f;
    [saveTaskBtn.layer setMasksToBounds:YES];
    [saveTaskBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [saveTaskBtn setTitle:@"注销" forState:UIControlStateNormal];
    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithCustomView:saveTaskBtn] autorelease];
    self.navigationItem.rightBarButtonItem = saveButton;
    
	// Do any additional setup after loading the view.
    
//    self.loginTableView = [[[UITableView alloc] init] autorelease];
//    self.loginTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
//    [self.loginTableView setAllowsSelection:NO];
//    CGRect rect = self.loginTableView.frame;
//    [self.loginTableView setFrame:rect];
//    loginTableView.delegate = self;
//    loginTableView.dataSource = self;
//    
//    [self.view addSubview:loginTableView];
    
//    btnLogin = [[CustomButton alloc] initWithFrame:CGRectMake(240, 230, 70, 40) image:[UIImage imageNamed:@"btn_center.png"]];
//    btnLogin.layer.cornerRadius = 6.0f;
//    [btnLogin.layer setMasksToBounds:YES];
//    [btnLogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
//    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
//    [btnLogin setFont:[UIFont boldSystemFontOfSize:20]];
//    [self.view addSubview:btnLogin];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    [accountView release];
    [btnLogin release];
    [super dealloc];
}

- (void)logout:(id)sender
{
    requestType = 0;
    HUD = [Tools process:@"正在注销" view:self.view];

    [AccountService logout:self];
}

- (void)login:(id)sender 
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
            [Tools msg:@"登录中" HUD:HUD];
            //HUD = [Tools process:@"登录中" view:self.view];
            
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
            [Tools alert:@"输入不全"];
        }
    
    //[self dismissModalViewControllerAnimated:NO];
    //[delegate ];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"请求响应数据: %@, %d", [request responseString], [request responseStatusCode]);
    if([request responseStatusCode] == 200)
    {
        if(requestType == 0)
        {
            //[Tools close:HUD];
            
            requestType = 1;
            
            [[Constant instance] setIsSaveUser:NO];
            [[Constant instance] setUsername:@""];
            [Constant saveToCache];
            
            CGRect rect = self.view.frame;
            loginTableView = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height) style:UITableViewStyleGrouped];
            [loginTableView setAutoresizesSubviews:YES];
            [loginTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
            loginTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
            [loginTableView setDataSource:self];
            [loginTableView setDelegate:self];
            
            [[self view] addSubview:loginTableView];
            
            [accountView setHidden:YES];
            
            CustomButton *loginTaskBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(5,5,50,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
            loginTaskBtn.layer.cornerRadius = 6.0f;
            [loginTaskBtn.layer setMasksToBounds:YES];
            [loginTaskBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
            [loginTaskBtn setTitle:@"登录" forState:UIControlStateNormal];
            UIBarButtonItem *loginButton = [[[UIBarButtonItem alloc] initWithCustomView:loginTaskBtn] autorelease];
            self.navigationItem.rightBarButtonItem = loginButton;
            
            [Tools alert:@"注销成功"];
        }
        else if(requestType == 1)
        {
            //[Tools msg:@"登录成功" HUD:HUD]; 
            
            NSArray* array = [request responseCookies];
            NSLog(@"array:%d",  array.count);
            
            NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:array];
            NSHTTPCookie *cookieA = [NSHTTPCookie cookieWithProperties:dict];
            NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            
            //[sharedHTTPCookie setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            [sharedHTTPCookie setCookie:cookieA];
            
#ifndef CODESHARP_VERSION
            [[Constant instance] setDomain:domainLabel.text];
#endif
            [[Constant instance] setUsername:textUsername.text];
            //TODO:自动保存用户登录
            [[Constant instance] setIsSaveUser:YES];

            [Constant saveToCache];
            
            requestType = 2;
            [TasklistService getTasklists:self];
            
            [Tools alert:@"登录成功"];
        }     
        else if(requestType == 2) {
            //[Tools close:HUD];

            NSMutableDictionary *tasklistsDict = [[request responseString] JSONValue];
            NSLog(@"dict count:%d",tasklistsDict.count);
            
            TasklistDao *tasklistDao = [[[TasklistDao alloc] init] autorelease];
            [tasklistDao deleteAll];
            
            for(NSString* key in tasklistsDict.allKeys)
            {
                NSString *value = [tasklistsDict objectForKey:key];
                
                //TODO:这里处理个人
                [tasklistDao addTasklist:key:value:@"per"];
            }
            
            [tasklistDao addTasklist:@"0" :@"默认列表" :@"列表"];
            
            [tasklistDao commitData];
            
            requestType = 1;
        }
    }
    else if([request responseStatusCode] == 400)
    {
        //[Tools close:HUD];
        
        [Tools alert:[request responseString]];
    }
    else
    {
        //[Tools close:HUD];
        
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
    if(tableView == self.loginTableView)
    {
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
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if(!cell)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"] autorelease];
        }
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
