//
//  AccountViewController.m
//  Cooper
//
//  Created by 磊 李 on 12-7-12.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountService.h"
@interface AccountViewController ()

@end

@implementation AccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Ark帐号设置", @"Ark帐号设置");
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *customBackButton = [[UIBarButtonItem alloc] initWithTitle:@"后退" 
                                                                         style:UIBarButtonItemStylePlain 
                                                                        target:self 
                                                                        action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = customBackButton;
    [customBackButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) return 3;
    else if(section == 1) return 1;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            SimplePickerInputTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"SimplePickerInputTableViewCell"];
            if(!cell1)
            {
                cell1 = [[[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SimplePickerInputTableViewCell"] autorelease];
                
                cell1.delegate = self;
                cell1.detailTextLabel.textColor = [UIColor blackColor];
                cell1.textLabel.text = @"域名";
            }
            
            if([[[Constant instance] domain] length] == 0)
                cell1.detailTextLabel.text = DEFAULT_DOMAIN;
            else
                cell1.detailTextLabel.text = [[Constant instance] domain];
            return cell1;
        }
        
        else if(indexPath.row == 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserNameCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserNameCell"] autorelease];
                
                cell.textLabel.text = @"用户名";
                
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
                textField.placeholder = @"请填写内容";
                [textField setReturnKeyType:UIReturnKeyDone];
                [textField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
                [textField setTextAlignment:UITextAlignmentRight];
                cell.accessoryView = textField;
            }
            
            UITextField *currentTextField = [cell accessoryView];
            currentTextField.text = [[Constant instance] username];
        }
        else if(indexPath.row == 2)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PasswordCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PasswordCell"] autorelease];
                
                cell.textLabel.text = @"密码";
                
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
                textField.placeholder = @"填写密码来验证";
                [textField setReturnKeyType:UIReturnKeyDone];
                [textField setSecureTextEntry:YES];
                [textField setTextAlignment:UITextAlignmentRight];
                [textField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
                cell.accessoryView = textField;
            }
            
            UITextField *currentTextField = [cell accessoryView];
            currentTextField.text = [[Constant instance] password];
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MonitorCell"] autorelease];

                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button setFrame:CGRectMake(0, 0, 120, 40)];
                [button setAlpha:0.8];
                [button addTarget:self action:@selector(saveSetting:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:@"验证并保存帐户" forState:UIControlStateNormal];

                cell.accessoryView = button;

                cell.backgroundColor = [UIColor clearColor];
                cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            }
        }
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

- (void)saveSetting:(id)sender
{
    UITableView *tv = self.tableView;
    UITableViewCell *cell1 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableViewCell *cell2 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITableViewCell *cell3 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    UITextField *textUsername = (UITextField*)cell2.accessoryView;
    UITextField *textPassword = (UITextField*)cell3.accessoryView;
    
    NSString *domain = cell1.detailTextLabel.text;
    NSString *username = textUsername.text;
    NSString *password = textPassword.text;
    
    if (![self checkAccount:domain username:username password:password]) {
        [Tools alert:@"域帐号／用户名／密码不可为空"];
        return;
    }
    
    HUD = [Tools process:@"正在登录" view:self.view];
    
    requestType = 0;
    [AccountService logout:self];
    
    //[AccountService arkLogin:domain username:username password:password delegate:self];
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
    NSLog(@"response:%@, %d", [request responseString], [request responseStatusCode]);
    

    if([request responseStatusCode] == 200 && [[request responseString] rangeOfString:@"loginSuccess"].length > 0)
    {
        if(requestType == 0)
        {
            requestType = 1;
            
            UITableView *tv = self.tableView;
            UITableViewCell *cell1 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            UITableViewCell *cell2 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            UITableViewCell *cell3 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            
            UITextField *textUsername = (UITextField*)cell2.accessoryView;
            UITextField *textPassword = (UITextField*)cell3.accessoryView;
            
            NSString *domain = cell1.detailTextLabel.text;
            NSString *username = textUsername.text;
            NSString *password = textPassword.text;
            
            if (![self checkAccount:domain username:username password:password]) {
                [Tools alert:@"域帐号／用户名／密码不可为空"];
                return;
            }
            
            [[Constant instance] setDomain:domain];
            [[Constant instance] setUsername:username];
            //[[Constant instance] setPassword:password];
            
            [Constant saveToCache];
            
            [AccountService arkLogin:domain username:username password:password delegate:self];
        }
        else
            [Tools msg:@"登录成功" HUD:HUD];     
    }
    else{
        [Tools msg:@"登录失败" HUD:HUD];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request error %@",request.error);
    [Tools failed:HUD];
}

@end
