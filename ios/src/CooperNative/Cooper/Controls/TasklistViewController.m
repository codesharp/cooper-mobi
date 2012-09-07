//
//  TasklistViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TasklistViewController.h"
#import "CooperService/TasklistService.h"
#import "SettingViewController.h"
#import "BaseNavigationController.h"
#import "TaskViewController.h"
#import <Foundation/NSCoder.h>

@implementation TasklistViewController

@synthesize tasklists;
@synthesize tasklistTableView;

# pragma mark - UI相关

- (void)loadView
{
    [super loadView];
    
    tasklistDao = [[TasklistDao alloc] init];
    
    self.title = APP_TITLE;
    
    //任务列表View
    self.tasklistTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped] autorelease];
    self.tasklistTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
    self.tasklistTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tasklistTableView.dataSource = self;
    self.tasklistTableView.delegate = self;
    [self.view addSubview:self.tasklistTableView];
    
    //左上自定义导航
    CustomToolbar *toolBar = [[[CustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 80, 45)] autorelease];
    
    //左上编辑按钮
    editBtn = [[InputPickerView alloc] initWithFrame:CGRectMake(0, 0, 38, 45)];
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 27, 27)] autorelease];
    UIImage *editImage = [UIImage imageNamed:EDIT_IMAGE];
    imageView.image = editImage;
    [editBtn addSubview:imageView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTasklist:)];
    [editBtn addGestureRecognizer:recognizer];
    editBtn.delegate = self;
    [recognizer release];
    [toolBar addSubview:editBtn];
    
    //左上同步按钮
    syncBtn = [[UIView alloc] initWithFrame:CGRectMake(40, 0, 38, 45)];
    UIImageView *settingImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 27, 27)] autorelease];
    UIImage *settingImage = [UIImage imageNamed:REFRESH_IMAGE];
    settingImageView.image = settingImage;
    [syncBtn addSubview:settingImageView];
    UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(syncTasklist:)];
    [syncBtn addGestureRecognizer:recognizer2];
    [recognizer2 release];
    [toolBar addSubview:syncBtn];
    
    UIBarButtonItem *barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolBar] autorelease]; 
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    //设置右选项卡中的按钮
    settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setFrame:CGRectMake(0, 10, 27, 27)];
    [settingBtn setBackgroundImage:[UIImage imageNamed:SETTING_IMAGE] forState:UIControlStateNormal];
    [settingBtn addTarget: self action: @selector(settingAction:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *settingButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    
    self.navigationItem.rightBarButtonItem = settingButtonItem; 
    
    [settingButtonItem release];
    
//    //点击View讲当前的Reponder隐藏
//    UITapGestureRecognizer *r = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFrontInput:)];
//    [self.view addGestureRecognizer:r];
//    [r release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog("@viewDidLoad事件触发")

    //登录用户进行同步
    if([[ConstantClass instance] username].length > 0)
    {
        HUD = [Tools process:LOADING_TITLE view:self.view];
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        [context setObject:@"GetTasklists" forKey:REQUEST_TYPE];
        [TasklistService getTasklists:context delegate:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog("@viewWillAppear事件触发")
    //如果未登录用户隐藏同步按钮
    syncBtn.hidden = [[ConstantClass instance] username].length == 0;

    [self loadTasklistData];
}

- (void)dealloc
{
    RELEASE(self.tasklists);
    RELEASE(self.tasklistTableView);
    RELEASE(tasklistDao);
    RELEASE(editBtn);
    RELEASE(syncBtn);
    RELEASE(settingBtn);
    [super dealloc];
}

- (void) loadTasklistData
{
    NSLog(@"开始初始化任务列表数据");
    
    self.tasklists = [NSMutableArray array];
    
    NSMutableArray *tasklistsArray = [tasklistDao getAllTasklist];
    
    //如果未登录用户并且无列表增加一条默认列表
    if(tasklistsArray.count == 0 
       && [[ConstantClass instance] username].length == 0)
    {
        [tasklistDao addTasklist:@"0" :@"默认列表" :@"personal"];
        [tasklistDao commitData];
        
        //添加再重新查询
        tasklistsArray = [tasklistDao getAllTasklist];
    }
    
    for(Tasklist *tasklist in tasklistsArray)
        [self.tasklists addObject:tasklist];

    NSMutableArray *newRecentlyIds = [NSMutableArray array];
    for(NSString *recentlyId in [[ConstantClass instance] recentlyIds])
    {
        int i = 0;
        for(i = 0; i < tasklists.count; i++)
        {
            Tasklist *tasklist = [tasklists objectAtIndex:i];
            if([tasklist.id isEqualToString:recentlyId])
            {
                break;
            }
        }
        if(i < tasklists.count)
        {
            [newRecentlyIds addObject: recentlyId];
        }
    }
    
    [[ConstantClass instance] setRecentlyIds:newRecentlyIds];
    [ConstantClass saveToCache];
    
    [self.tasklistTableView reloadData];
}

# pragma mark - 相关动作事件

- (void)syncTasklist:(id)sender
{
    HUD.labelText = LOADING_TITLE;
    [HUD show:YES];
    
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"GetTasklists" forKey:REQUEST_TYPE];
    [TasklistService getTasklists:context delegate:self];
    
    [self loadTasklistData];
}

- (void)settingAction:(id)sender
{
    //设置
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController"
                                                                                           bundle:nil
                                                                                         setTitle:@"设置" 
                                                                                         setImage:SETTING_IMAGE];
    
    BaseNavigationController *setting_navViewController = [[[BaseNavigationController alloc] initWithRootViewController:settingViewController] autorelease];
    
    //后退按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 5, 25, 25);
    [backBtn setBackgroundImage:[UIImage imageNamed:BACK_IMAGE] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    settingViewController.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    
    [self.navigationController presentModalViewController:setting_navViewController animated:YES];
}

- (void)goBack:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)addTasklist:(id)sender
{
    [editBtn becomeFirstResponder];
}

- (void)resignFrontInput:(id)sender
{
    [editBtn resignFirstResponder];
}

- (void)send:(NSString *)value
{
    NSString *guid = [Tools stringWithUUID];
    NSString *tasklistId = [NSString stringWithFormat:@"temp_%@", guid];
    
    HUD = [Tools process:LOADING_TITLE view:self.view];
    
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"CreateTasklist" forKey:REQUEST_TYPE];
    [context setObject:tasklistId forKey:@"TasklistId"];
    [context setObject:value forKey:@"TasklistName"];
    
    [TasklistService syncTasklist:value :@"personal" :context :self];

    [Tools close:HUD];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"请求响应数据: %@, %d",request.responseString, request.responseStatusCode);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    if([requestType isEqualToString:@"GetTasklists"])
    {
        if(request.responseStatusCode == 200)
        {
            [Tools close:HUD];
            
            NSMutableDictionary *tasklistsDict = [[request responseString] JSONValue];
            
            //删除当前账户所有任务列表
            [tasklistDao deleteAll];
            
            for(NSString* key in tasklistsDict.allKeys)
            {
                NSString *value = [tasklistsDict objectForKey:key];
                
                [tasklistDao addTasklist:key:value:@"personal"];
            }
            
            //加上默认列表，判断下未登录用户的默认列表
            [tasklistDao addTasklist:@"0" :@"默认列表" :@"personal"];
            
            [tasklistDao commitData];
            
            [self loadTasklistData];
        }
        else
        {
            [Tools failed:HUD];
        }
    }
    else if([requestType isEqualToString:@"CreateTasklist"])
    {
        if(request.responseStatusCode == 200)
        {
            [Tools close:HUD];
            
            NSString *tasklistId = [userInfo objectForKey:@"TasklistId"];
            NSString *tasklistName = [userInfo objectForKey:@"TasklistName"];
            
            [tasklistDao addTasklist:tasklistId :tasklistName :@"personal"];
            
            NSString* newId = [request responseString];
            [tasklistDao adjustId:tasklistId withNewId:newId];
            
            [tasklistDao commitData];
            
            [self loadTasklistData];
        }
        else
        {
            [Tools failed:HUD];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"错误异常: %@", request.error);
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    if([requestType isEqualToString:@"GetTasklists"] && request == nil)
    {
        [Tools msg:NOT_NETWORK_MESSAGE HUD:HUD];
        return;
    }
    [Tools close:HUD];
}

- (void)addRequstToPool:(ASIHTTPRequest *)request
{
    NSLog(@"发送请求URL: %@", request.url);
}

# pragma mark - 任务列表相关委托事件

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([[[ConstantClass instance] recentlyIds] count] > 0)
        return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[[ConstantClass instance] recentlyIds] count] > 0)
    {
        if(section == 0)
        {
            NSMutableArray *recentlyIds = (NSMutableArray*)[[ConstantClass instance] recentlyIds];
            
            int count = 0;
            for(int i = 0; i < tasklists.count; i++)
            {
                Tasklist* l = (Tasklist*)[tasklists objectAtIndex:i];
                if([recentlyIds containsObject:l.id])
                {
                    count++;
                }
            }
            
            return count;
        }
        else if(section == 1)
            return self.tasklists.count;
        else 
            return 0;
    }
    return self.tasklists.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([[[ConstantClass instance] recentlyIds] count] > 0)
    {
        if(section == 0)
        {
            return @"最近查看";
        }
        else 
        {
            return @"所有任务列表";
        }
    }
    else {
        if(self.tasklists.count > 0)
        {
            return @"所有任务列表";
        }
        else 
        {
            return @"";
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
        selectedView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
        //设置选中后cell的背景颜色
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = selectedView;
        [selectedView release];
    }
    
    //如果包含最近点击的任务列表
    if([[[ConstantClass instance] recentlyIds] count] > 0)
    {
        if(indexPath.section == 0)
        {
            NSMutableArray *recentlyIds = (NSMutableArray*)[[ConstantClass instance] recentlyIds];
            
            NSString* tasklistId = [recentlyIds objectAtIndex:indexPath.row];
            for(int i = 0; i < tasklists.count; i++)
            {
                Tasklist* l = (Tasklist*)[tasklists objectAtIndex:i];
                if([tasklistId isEqualToString: l.id])
                {
                    cell.textLabel.text = l.name;
                    break;
                }
            }
        }
        else 
        {
            Tasklist* tasklist = [tasklists objectAtIndex:indexPath.row];
            cell.textLabel.text = tasklist.name;
        }
    }
    else {
        Tasklist* tasklist = [tasklists objectAtIndex:indexPath.row];
        cell.textLabel.text = tasklist.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [editBtn resignFirstResponder];
    
    //点击产生的最近任务列表记录，目前只保留4条记录，算法需要优化
    NSString *tasklistId;
    NSMutableArray *recentlyIds = (NSMutableArray*)[[ConstantClass instance] recentlyIds];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* name = cell.textLabel.text;
    for(int i = 0; i < tasklists.count; i++)
    {
        Tasklist* l = (Tasklist*)[tasklists objectAtIndex:i];
        if([l.name isEqualToString:name])
        {
            tasklistId = l.id;
            break;
        }
    }
    
    if([recentlyIds count] == 0)
    {
        recentlyIds = [NSMutableArray array];
        [recentlyIds addObject:tasklistId];
    }
    else {
        if([recentlyIds containsObject:tasklistId])
        {
            [recentlyIds removeObject:tasklistId];
        }
        [recentlyIds insertObject:tasklistId atIndex:0];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    int i = 0;
    for(NSString* r in recentlyIds)
    {
        [array addObject:r];
        i++;
        if(i > RECENTLYTASKLIST_COUNT - 1)
            break;
    }
    
    [[ConstantClass instance] setRecentlyIds:array];
    [ConstantClass saveToCache];

    ///////////////////////////////////////////////
    
    NSLog(@"当前选择的任务列表编号: %@", tasklistId);
    
    //切换到任务界面
    
    //个人任务
    TaskViewController *taskViewController = [[[TaskViewController alloc] initWithNibName:@"TaskViewController" 
                                                                                   bundle:nil 
                                                                                 setTitle:@"个人任务" 
                                                                                 setImage:@"task.png"] autorelease];
    taskViewController.currentTasklistId = tasklistId;
    
    //已完成
    TaskViewController *completeTaskViewController = [[[TaskViewController alloc] initWithNibName:@"TaskViewController" 
                                                                                           bundle:nil 
                                                                                         setTitle:@"已完成" 
                                                                                         setImage:@"complete.png"] autorelease];
    completeTaskViewController.filterStatus = @"1";         //完成状态设置为1
    completeTaskViewController.currentTasklistId = tasklistId;
    
    //未完成
    TaskViewController *incompleteTaskViewController = [[[TaskViewController alloc] initWithNibName:@"TaskViewController" 
                                                                                             bundle:nil 
                                                                                           setTitle:@"未完成" 
                                                                                           setImage:@"incomplete.png"] autorelease];
    incompleteTaskViewController.filterStatus = @"0";       //未完成状态设置为0
    incompleteTaskViewController.currentTasklistId = tasklistId;
    
    //设置
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" 
                                                                                           bundle:nil 
                                                                                         setTitle:@"设置" 
                                                                                         setImage:SETTING_IMAGE];    
    
    UITabBarController *tabBarController = [[[UITabBarController alloc] init] autorelease];

    [tabBarController.navigationItem setHidesBackButton:YES];
    if(MODEL_VERSION > 5.0)
    {
        [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:TABBAR_BG_IMAGE]];
        [tabBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selectedbg.png"]];
    }
    else {
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:TABBAR_BG_IMAGE]] autorelease];
        [imageView setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], 49)];
        [tabBarController.tabBar insertSubview:imageView atIndex:0];
    }
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:taskViewController, completeTaskViewController, incompleteTaskViewController, settingViewController, nil];
    tabBarController.delegate = self;
   
    for (UIView *view in tabBarController.tabBar.subviews)
    {      
        if ([NSStringFromClass([view class]) isEqualToString:@"UITabBarButton"])
        {
            for (UIView *subview in view.subviews)
            {                  
                if ([subview isKindOfClass:[UILabel class]])
                {
                    UILabel *label = (UILabel *)subview;
                    
                    [label setTextColor:[UIColor whiteColor]];
                }
            }
        }
    } 
    
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:tabBarController animated:NO];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    for (UIView *view in tabBarController.tabBar.subviews)
    {      
        if ([NSStringFromClass([view class]) isEqualToString:@"UITabBarButton"])
        {
            for (UIView *subview in view.subviews)
            {                                    
                if ([subview isKindOfClass:[UILabel class]])
                {
                    UILabel *label = (UILabel *)subview;
                    label.textColor = [UIColor whiteColor];
                }
            }
        }
    } 
    
//    if(tabBarController.selectedIndex == 0
//       || tabBarController.selectedIndex == 1 
//       || tabBarController.selectedIndex == 2)
//    {
//        TaskViewController* controller = (UINavigationController*)[tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex];
//        
//        if(controller == nil)
//        {
//            NSLog(@"控制器描述: %@", [controller description]);
//        }
//        else 
//        {
//            [controller loadTaskData];
//        }
//    }
}

@end
