//
//  AccountViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-30.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AccountViewController.h"
#import "AppDelegate.h"
#import "CooperService/TasklistService.h"
#import "CooperService/AccountService.h"
#import "CooperCore/Tasklist.h"
#import "CooperService/TaskService.h"

@implementation AccountViewController

@synthesize textUsername;
@synthesize textPassword;
@synthesize loginTableView;
@synthesize accountView;
@synthesize btnLogin;
#ifdef __ALI_VERSION__
@synthesize domainLabel;
#endif

#pragma mark - 页面相关事件

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
    NSLog(@"loadView");
    
    //当前面板创建
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Tools screenMaxWidth], [Tools screenMaxHeight])];
    contentView.autoresizesSubviews = YES;
    contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.View = contentView;
    [contentView release];
    
    //登录View
    CGRect rect = self.view.frame;
    loginTableView = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + 20, rect.size.width, rect.size.height) style:UITableViewStyleGrouped];
    loginTableView.autoresizesSubviews = YES;
    loginTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    loginTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
    loginTableView.allowsSelection = NO;
    loginTableView.dataSource = self;
    loginTableView.delegate = self;
    [self.view addSubview:loginTableView]; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    
    taskDao = [[TaskDao alloc] init];
    taskIdxDao = [[TaskIdxDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
    tasklistDao = [[TasklistDao alloc] init];
    
    //后退按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:BACK_IMAGE] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    
    //保存按钮（相当于切换用户）
    CustomButton *saveTaskBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(5,5,70,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
    saveTaskBtn.layer.cornerRadius = 6.0f;
    [saveTaskBtn.layer setMasksToBounds:YES];
    [saveTaskBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [saveTaskBtn setTitle:@"保存" forState:UIControlStateNormal];
    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithCustomView:saveTaskBtn] autorelease];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
#ifdef __ALI_VERSION__
    [domainLabel release];
#endif
    [textUsername release];
    [textPassword release];
    [loginTableView release];
    [accountView release];
    [btnLogin release];
    RELEASE(taskDao);
    RELEASE(taskIdxDao);
    RELEASE(changeLogDao);
    RELEASE(tasklistDao);
    [super dealloc];
}

#pragma mark - 相关动作事件

- (void)goBack:(id)sender
{
    [Tools layerTransition:self.navigationController.view from:@"left"]; 
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)login:(id)sender 
{
    lock_counter = 0;
    
    HUD = [Tools process:LOADING_TITLE view:self.view];
    
    if([[ConstantClass instance] username].length > 0)
    {
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        [context setObject:@"Logout" forKey:REQUEST_TYPE];
        
        [AccountService logout:context delegate:self];
    }
    else {
        [self loginServiceAction];
    }
}

- (void)syncAllLocalData
{
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"SyncAll" forKey:@"RequestType"];
    
    NSMutableArray *tasklists = [tasklistDao getAllTasklistByGuest];
    
    lock_counter = tasklists.count;
    
    for(Tasklist *tasklist in tasklists)
    {
        [TaskService syncTask:tasklist.id context:context delegate:self];
    }
}

- (void)loginServiceAction
{
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"Login" forKey:REQUEST_TYPE];
    
#ifdef __ALI_VERSION__
    if ([domainLabel.text length] > 0 
        && [textUsername.text length] > 0
        && [textPassword.text length] > 0) 
#else
        if([textUsername.text length] > 0
           && [textPassword.text length] > 0)
#endif
        {
            [Tools msg:@"登录中" HUD:HUD];
            
#ifdef __ALI_VERSION__
            [AccountService login:domainLabel.text 
                         username:textUsername.text 
                         password:textPassword.text 
                          context:context
                         delegate:self];
#else
            [AccountService login:textUsername.text
                         password:textPassword.text
                          context:context
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
    NSLog(@"请求响应数据: %@, %d", [request responseString], [request responseStatusCode]);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    if([requestType isEqualToString:@"Logout"])
    {
        if(request.responseStatusCode == 200)
        {
            [self loginServiceAction];
        }
    }
    else if([requestType isEqualToString:@"Login"])
    {
        if(request.responseStatusCode == 200)
        {
#ifdef __ALI_VERSION__
            if([[request responseString] rangeOfString: @"window.opener.loginSuccess"].length == 0)
            {
                [Tools close:HUD];
                
                [Tools alert:@"用户名和密码不正确"];
                
                return;
            }
#endif
            //[Tools msg:@"登录成功" HUD:HUD];
            
            NSArray* array = [request responseCookies];
            NSLog(@"array:%d",  array.count);
            
            NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:array];
            NSHTTPCookie *cookieA = [NSHTTPCookie cookieWithProperties:dict];
            NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            
            //[sharedHTTPCookie setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            [sharedHTTPCookie setCookie:cookieA];
            
#ifdef __ALI_VERSION__
            [[ConstantClass instance] setDomain:domainLabel.text];
#endif
            [[ConstantClass instance] setUsername:textUsername.text];
            [[ConstantClass instance] setIsGuestUser:YES];
            
            [ConstantClass saveToCache];
            
            //把当前用户数据先全部同步到服务端
            [self syncAllLocalData];
            
            [Tools alert:@"保存成功"];
        }
        else if(request.responseStatusCode == 400)
        {
            [Tools alert:[request responseString]];
        }
        else
        {
            [Tools close:HUD];
            
            [Tools alert:@"用户名和密码不正确"];
        }
    }
    else if([requestType isEqualToString:@"SyncAll"])
    {
        if(request.responseStatusCode == 200)
        {
            lock_counter--;
            if(lock_counter <= 0)
            {
                NSMutableDictionary *context = [NSMutableDictionary dictionary];
                [context setObject:@"GetTasks" forKey:REQUEST_TYPE];
                [TasklistService getTasklists:context delegate:self];
            }
        }
        else
        {
            [Tools failed:HUD];
        }
    }
    else if([requestType isEqualToString:@"GetTasks"])
    {
        if(request.responseStatusCode == 200)
        {
            NSMutableDictionary *tasklistsDict = [[request responseString] JSONValue];
            
            [tasklistDao deleteAll];
            
            for(NSString* key in tasklistsDict.allKeys)
            {
                NSString *value = [tasklistsDict objectForKey:key];
                
                [tasklistDao addTasklist:key:value:@"personal"];
            }
            
            [tasklistDao addTasklist:@"0" :@"默认列表" :@"personal"];
            
            [tasklistDao commitData];
        }
        else
        {
            [Tools failed:HUD];
        }
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //[self removeRequstFromPool:request];
    
    NSLog(@"错误异常: %@", request.error);
    [Tools msg:NOT_NETWORK_MESSAGE HUD:HUD];
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
    return 2;
#else
    return 3;
#endif
}
//填充单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSString *identifier = @"BaseCell";
#ifdef __ALI_VERSION__
    if(indexPath.row == 0)
    {
        //创建域Cell
        identifier = @"DomainCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
            cell = [self createDomainCell:identifier];
    }
    else if(indexPath.row == 1)
    {
        //创建用户名Cell
        identifier = @"UsernameCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
            cell = [self createUsernameCell:identifier];   
    }
    else if(indexPath.row == 2)
    {
        //创建密码Cell
        identifier = @"PasswordCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
            cell = [self createPasswordCell:identifier];  
    }   
#else
    if(indexPath.row == 0)
    {
        //创建用户名Cell
        identifier = @"UsernameCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
            cell = [self createUsernameCell:identifier];  
    }
    else if(indexPath.row == 1)
    {
        //创建密码Cell
        identifier = @"PasswordCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
            cell = [self createPasswordCell:identifier]; 
    }
#endif
    return cell;
}



#ifdef __ALI_VERSION__

- (void)tableViewCell:(DomainLabel *)label didEndEditingWithValue:(NSString *)value
{
    label.text = value;
}

- (void)selectDomain
{
    [domainLabel becomeFirstResponder];
}
#endif

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 35.0f;
//}

- (UITableViewCell*)createDomainCell:(NSString*)identifier
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
    
#ifdef __ALI_VERSION__
    domainLabel = [[DomainLabel alloc] initWithFrame:CGRectMake(0, 0, 210, 30)];
    domainLabel.text = DEFAULT_DOMAIN;
    [domainLabel setBackgroundColor:[UIColor clearColor]];
    domainLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *recoginzer = [[UITapGestureRecognizer alloc] 
                                          initWithTarget:self 
                                          action:@selector(selectDomain)];
    [domainLabel addGestureRecognizer:recoginzer];
    domainLabel.delegate = self;
    [recoginzer release];
    
    cell.textLabel.text = @"域名";
    cell.accessoryView = domainLabel;
#endif  
    return cell;
}

- (UITableViewCell*)createUsernameCell:(NSString*)identifier
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UsernameCell"] autorelease];
    
    CGFloat width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 660 : 285;
    self.textUsername = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 20)];  
    
    [self.textUsername setPlaceholder:@"用户名"]; 
    [self.textUsername setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.textUsername setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.textUsername setReturnKeyType:UIReturnKeyDone];
    [self.textUsername addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    cell.accessoryView = self.textUsername;
    
    if([[ConstantClass instance] username].length > 0)
    {
        self.textUsername.text = [[ConstantClass instance] username];
    }
    
    return cell;
}

- (UITableViewCell*)createPasswordCell:(NSString*)identifier
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PasswordCell"] autorelease];
    
    CGFloat width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 660 : 285;
    self.textPassword = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, 20)]; 
    [self.textPassword setSecureTextEntry:YES];
    [self.textPassword setPlaceholder:@"密码"];
    [self.textPassword setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.textPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.textPassword setReturnKeyType:UIReturnKeyDone];
    [self.textPassword addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    cell.accessoryView = self.textPassword;
    
    if([[ConstantClass instance] username].length > 0)
    {
        self.textPassword.text = @"***********";
    }
    
    return cell;
}

@end
