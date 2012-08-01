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
@synthesize btnSkip;
#ifdef __ALI_VERSION__
@synthesize domainLabel;
#endif

#pragma mark - UI相关

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* login_btn_text = [[[SysConfig instance] keyValue] objectForKey:@"login_btn_text"];
    NSString* skip_btn_text = [[[SysConfig instance] keyValue] objectForKey:@"skip_btn_text"];
    
    //登录View
    self.loginTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
    self.loginTableView.allowsSelection = NO;
    CGRect rect = self.loginTableView.frame;
    self.loginTableView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 120);
    self.loginTableView.delegate = self;
    self.loginTableView.dataSource = self;
    
    //登录按钮
    self.btnLogin = [[CustomButton alloc] initWithFrame:CGRectMake(160, 290, 70, 40) 
                                             image:[UIImage imageNamed:@"btn_center.png"]];
    self.btnLogin.layer.cornerRadius = 6.0f;
    self.btnLogin.layer.masksToBounds = YES;
    [self.btnLogin addTarget:self 
                      action:@selector(login) 
            forControlEvents:UIControlEventTouchUpInside];
    [self.btnLogin setTitle:login_btn_text 
              forState:UIControlStateNormal];
    [self.btnLogin setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:self.btnLogin];
    
    //跳过按钮
    //TODO:按钮背景
    self.btnSkip = [[CustomButton alloc] initWithFrame:CGRectMake(240, 290, 70, 40) 
                                                  image:[UIImage imageNamed:@"btn_center.png"]];
    self.btnSkip.layer.cornerRadius = 6.0f;
    self.btnSkip.layer.masksToBounds = YES;
    [self.btnSkip addTarget:self 
                      action:@selector(skip) 
            forControlEvents:UIControlEventTouchUpInside];
    [self.btnSkip setTitle:skip_btn_text 
                   forState:UIControlStateNormal];
    [self.btnSkip setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:self.btnSkip];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (void)dealloc 
{
#ifdef __ALI_VERSION__
    [self.domainLabel release];
#endif
    [textUsername release];
    [textPassword release];
    [loginTableView release];
    [btnLogin release];
    RELEASE(self.btnSkip);
    [super dealloc];
}

#pragma mark - 触发自定义事件

- (void)login 
{
#ifdef __ALI_VERSION__
    if (self.domainLabel.text.length > 0 
        && self.textUsername.text.length > 0
        && self.textPassword.text.length > 0) 
#else
        if(self.textUsername.text.length > 0
           && self.textPassword.text.length > 0)
#endif
        {
            HUD = [Tools process:@"登录中" view:self.view];
            
#ifdef __ALI_VERSION__
            [AccountService login:self.domainLabel.text 
                         username:self.textUsername.text 
                         password:self.textPassword.text 
                         delegate:self];
#else
            [AccountService login:self.textUsername.text
                         password:self.textPassword.text
                         delegate:self];
#endif
        }
        else 
        {
            [Tools alert:@"请输入用户名和密码"];
        }
}

- (void)skip
{
    //TODO:自动保存用户登录
    [[ConstantClass instance] setIsSaveUser:YES];
    [ConstantClass saveToCache];
    
    [self dismissModalViewControllerAnimated:NO];
    
    [delegate loginExit];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [Tools close:HUD];
    //TODO:暂时采用字符串包含来判断是否登录成功
    NSLog(@"请求响应数据: %@, %d"
          , [request responseString]
          , [request responseStatusCode]);
    if([request responseStatusCode] == 200)
    {
        NSArray* array = [request responseCookies];
        NSLog(@"array:%d",  array.count);
        
        NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:array];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dict];
        NSHTTPCookieStorage *sharedHTTPCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
        [sharedHTTPCookie setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        [sharedHTTPCookie setCookie:cookie];
        
#ifdef __ALI_VERSION__
        [[ConstantClass instance] setDomain:self.domainLabel.text];
#endif
        [[ConstantClass instance] setUsername:self.textUsername.text];
        //TODO:自动保存用户登录
        [[ConstantClass instance] setIsSaveUser:YES];
        [ConstantClass saveToCache];
        
        [self dismissModalViewControllerAnimated:NO];
        
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
    [Tools failed:HUD];
    NSLog(@"请求异常: %@",request.error);
}

- (void)addRequstToPool:(ASIHTTPRequest *)request
{
    NSLog(@"发送请求路径：%@",request.url);
}

#ifdef __ALI_VERSION__

# pragma mark - 域账号相关事件

- (void)tableViewCell:(DomainLabel *)label didEndEditingWithValue:(NSString *)value
{
    label.text = value;
}

- (void)selectDomain
{
    [domainLabel becomeFirstResponder];
}

#endif

# pragma mark - 登录TableView相关的委托事件

//获取TableView的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//获取在制定的分区编号下的纪录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#ifdef __ALI_VERSION__
    return 3;
#else
    return 2;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}

- (UITableViewCell*)createDomainCell:(NSString*)identifier
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
    
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
    return cell;
}

@end
