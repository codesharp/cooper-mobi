//
//  TasklistViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "TasklistViewController.h"
//#import "TasklistDao.h"
#import "TasklistService.h"
#import "SettingViewController.h"
#import "BaseNavigationController.h"

@implementation TasklistViewController

@synthesize tasklists;
@synthesize tasklistTableView;
@synthesize tasklistDao;

- (void)loadView
{
    [super loadView];
    
    self.title = @"cooper:task";
    
    self.tasklistTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped] autorelease];
    self.tasklistTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
    self.tasklistTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tasklistTableView.dataSource = self;
    self.tasklistTableView.delegate = self;
    [self.view addSubview:self.tasklistTableView];
    
    CustomToolbar *toolBar = [[[CustomToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 45.0f)] autorelease];
    editBtn = [InputPickerButton buttonWithType:UIButtonTypeCustom];
    [editBtn setFrame:CGRectMake(5, 10, 27, 27)];
    editBtn.contentMode = UIViewContentModeScaleToFill;
    editBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [editBtn setBackgroundImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    //[editBtn addTarget: self action: @selector(addTasklist:) forControlEvents: UIControlEventTouchUpInside];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginAddTasklist:)];
    [editBtn addGestureRecognizer:recognizer];
    editBtn.delegate = self;
    [recognizer release];
    
    [toolBar addSubview:editBtn];
    
    UIButton *syncBtn = [UIButton buttonWithType:UIButtonTypeCustom]; 
    [syncBtn setFrame:CGRectMake(45, 10, 27, 27)];
    [syncBtn setBackgroundImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    [syncBtn addTarget: self action: @selector(syncTasklist:) forControlEvents: UIControlEventTouchUpInside];
    [toolBar addSubview:syncBtn];
    
    UIBarButtonItem *barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolBar] autorelease]; 
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    //设置右选项卡中的按钮
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setFrame:CGRectMake(0, 10, 27, 27)];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    [settingBtn addTarget: self action: @selector(settingAction:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *settingButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:settingBtn] autorelease];
    
    self.navigationItem.rightBarButtonItem = settingButtonItem; 
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)beginAddTasklist:(id)sender
{
    NSLog(@"beginAddTasklist");
    [editBtn becomeFirstResponder];
}

- (void)send:(NSString *)value
{
    NSString *dateString = [Tools NSDateToNSString:[NSDate date]];
    NSString *guid = [Tools stringWithUUID];
    NSString *tempTasklistId = [NSString stringWithFormat:@"temp_%@", guid];
    
    HUD = [Tools process:@"加载中" view:self.view];
    
    NSString* responseString = [TasklistService syncTasklist:value :@"personal" :self];
    
    if(responseString != nil)
    {
        NSLog(@"服务端处理CreateTaskList完毕，返回ID:%@", responseString);
        
        [tasklistDao addTasklist:tempTasklistId :value :@"per"];
        
        NSString* newId = responseString;
        [tasklistDao adjustId:tempTasklistId withNewId:newId];
        
        //TODO:add changelog
        
        [tasklistDao commitData];
        
        [self loadTasklistData];
        
    }
    else {
        [Tools alert:@"无法同步到服务端，请检查网络"];
    }
    
    [Tools close:HUD];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    tasklistDao = [[TasklistDao alloc] init];
	
    HUD = [Tools process:@"加载中" view:self.view];
    
    requestType = 0;
    //[TasklistService syncTasklist:self];
    [TasklistService getTasklists:self];

    //[self loadTasklistData];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    [self loadTasklistData];
    
    //[self.tasklistTableView reloadData];
}

- (void)dealloc
{
    RELEASE(self.tasklists);
    RELEASE(self.tasklistTableView);
    RELEASE(tasklistDao);
    RELEASE(editBtn);
    [super dealloc];
}

- (void)syncTasklist:(id)sender
{
    HUD.labelText = @"加载中";
    [HUD show:YES];
    
    requestType = 0;
    //[TasklistService syncTasklist:self];
    [TasklistService getTasklists:self];
    
    [self loadTasklistData];
}

- (void)settingAction:(id)sender
{
    //设置
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil setTitle:@"设置" setImage:@"setting.png"];
    
    BaseNavigationController *setting_navViewController = [[[BaseNavigationController alloc] initWithRootViewController:settingViewController] autorelease];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    settingViewController.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    
    [self.navigationController presentModalViewController:setting_navViewController animated:YES];
}

- (void)addTasklist:(id)sender
{
    //设置
    TasklistEditController *tasklistEditController = [[[TasklistEditController alloc] init] autorelease];
    
    BaseNavigationController *tasklistEdit_navViewController = [[[BaseNavigationController alloc] initWithRootViewController:tasklistEditController] autorelease];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    tasklistEditController.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    
    [self.navigationController presentModalViewController:tasklistEdit_navViewController animated:YES];
}

- (void)goBack:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void) loadTasklistData
{
    NSLog(@"开始初始化任务列表数据");
    
    self.tasklists = [NSMutableArray array];
    
    NSMutableArray *tasklistsArray = [tasklistDao getAllTasklist];
    
    NSMutableArray *recentlyIds = (NSMutableArray*)[[Constant instance] recentlyIds];
    
    for(Tasklist *tasklist in tasklistsArray)
    { 
        [self.tasklists addObject:tasklist];
    }

    NSMutableArray *newRecentlyIds = [NSMutableArray array];
    for(NSString *recentlyId in [[Constant instance] recentlyIds])
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
    
    [[Constant instance] setRecentlyIds:newRecentlyIds];
    [Constant saveRecentlyIdsToCache];
    
    [self.tasklistTableView reloadData];
}

# pragma mark request callback

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"请求响应数据: %@, %d",[request responseString], [request responseStatusCode]);
    
    if(requestType == 0)
    {
        if([request responseStatusCode] == 200)
        {
            [Tools close:HUD];
            
            NSMutableDictionary *tasklistsDict = [[request responseString] JSONValue];
            NSLog(@"dict count:%d",tasklistsDict.count);
            
            [tasklistDao deleteAll];
            
            for(NSString* key in tasklistsDict.allKeys)
            {
                NSString *value = [tasklistsDict objectForKey:key];
                
                //TODO:这里处理个人
                [tasklistDao addTasklist:key:value:@"per"];
            }
            
            [tasklistDao addTasklist:@"0" :@"默认列表" :@"列表"];
            
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
    [Tools close:HUD];
    NSLog(@"错误异常: %@", request.error);
}

- (void)addRequstToPool:(ASIHTTPRequest *)request
{
    NSLog(@"发送请求URL: %@", request.url);
}

# pragma mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView");
    if([[[Constant instance] recentlyIds] count] > 0)
        return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[[Constant instance] recentlyIds] count] > 0)
    {
        if(section == 0)
        {
            NSMutableArray *recentlyIds = (NSMutableArray*)[[Constant instance] recentlyIds];
            
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
    if([[[Constant instance] recentlyIds] count] > 0)
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
    NSLog(@"cellForRowAtIndexPath");
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
    
    if([[[Constant instance] recentlyIds] count] > 0)
    {
        if(indexPath.section == 0)
        {
            NSMutableArray *recentlyIds = (NSMutableArray*)[[Constant instance] recentlyIds];
            
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
    
    NSString *tasklistId;
    NSMutableArray *recentlyIds = (NSMutableArray*)[[Constant instance] recentlyIds];
    
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
    [[Constant instance] setRecentlyIds:recentlyIds];
    [Constant saveRecentlyIdsToCache];

    NSLog(@"当前选择的任务列表编号: %@", tasklistId);
    
    //个人任务
    TaskViewController *taskViewController = [[[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil setTitle:@"个人任务" setImage:@"task.png"] autorelease];
    taskViewController.currentTasklistId = tasklistId;
    
    //已完成
    TaskViewController *completeTaskViewController = [[[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil setTitle:@"已完成" setImage:@"complete.png"] autorelease];
    completeTaskViewController.filterStatus = @"1";
    completeTaskViewController.currentTasklistId = tasklistId;
    
    //未完成
    TaskViewController *incompleteTaskViewController = [[[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil setTitle:@"未完成" setImage:@"incomplete.png"] autorelease];
    incompleteTaskViewController.filterStatus = @"0";
    incompleteTaskViewController.currentTasklistId = tasklistId;
    
    //设置
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil setTitle:@"设置" setImage:@"setting.png"];
        
    
    UITabBarController *tabBarController = [[[UITabBarController alloc] init] autorelease];

    [tabBarController.navigationItem setHidesBackButton:YES];
    if(MODEL_VERSION > 5.0)
    {
        [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:TABBAR_BG_IMAGE]];
    }
    else {
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:TABBAR_BG_IMAGE]] autorelease];
        [imageView setFrame:CGRectMake(0, 0, 320, 49)];
        [tabBarController.tabBar insertSubview:imageView atIndex:0];
    }
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:taskViewController, completeTaskViewController, incompleteTaskViewController, settingViewController, nil];
    tabBarController.delegate = self;
    
//    UIColor *color = [UIColor colorWithRed:208.0/255 green:58.0/255 blue:64.0/255 alpha:1.0];
//    [tabBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"edit.png"]];
   
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
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
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
                    
                    [label setTextColor:[UIColor whiteColor]];
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
