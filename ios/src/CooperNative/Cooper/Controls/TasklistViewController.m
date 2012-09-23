//
//  TasklistViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TasklistViewController.h"
#import "SettingViewController.h"
#import "BaseNavigationController.h"
#import "TaskController.h"
#import "CustomToolbar.h"
#import "CooperCore/Tasklist.h"
#import "CooperService/TasklistService.h"

@implementation TasklistViewController

@synthesize tasklists;
@synthesize setting_navViewController;

# pragma mark - UI相关

- (void)loadView
{
    [super loadView];
    
    tasklistDao = [[TasklistDao alloc] init];
    taskDao = [[TaskDao alloc] init];
    taskIdxDao = [[TaskIdxDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
    tasklistService = [[TasklistNewService alloc] init];
    taskService = [[TaskNewService alloc] init];
    
    self.title = @"个人任务";
    
    UITapGestureRecognizer *recognizer = nil;
    
    //任务列表View
    tasklistTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tasklistTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
    tasklistTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tasklistTableView.dataSource = self;
    tasklistTableView.delegate = self;
    [self.view addSubview:tasklistTableView];
    
    //左上自定义导航
    CustomToolbar *toolBar = [[CustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 120, 45)];
    
    int left = 0;
    if(![[[ConstantClass instance] loginType] isEqualToString:@"anonymous"])
    { 
        //左上后退按钮
        backBtn = [[UIView alloc] initWithFrame:CGRectMake(left, 0, 38, 45)];
        UIImageView *backImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 27, 27)] autorelease];
        UIImage *backImage = [UIImage imageNamed:BACK_IMAGE];
        backImageView.image = backImage;
        [backBtn addSubview:backImageView];
        recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToOption:)];
        [backBtn addGestureRecognizer:recognizer];
        [recognizer release];
        [toolBar addSubview:backBtn];
        
        left += 40;
    }

    //左上编辑按钮
    editBtn = [[InputPickerView alloc] initWithFrame:CGRectMake(left, 0, 38, 45)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 27, 27)];
    UIImage *editImage = [UIImage imageNamed:EDIT_IMAGE];
    imageView.image = editImage;
    [editBtn addSubview:imageView];
    [imageView release];
    
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTasklist:)];
    [editBtn addGestureRecognizer:recognizer];
    editBtn.delegate = self;
    [recognizer release];
    [toolBar addSubview:editBtn];
    
    //左上同步按钮
    syncBtn = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 38, 45)];
    UIImageView *settingImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 27, 27)] autorelease];
    UIImage *settingImage = [UIImage imageNamed:REFRESH_IMAGE];
    settingImageView.image = settingImage;
    [syncBtn addSubview:settingImageView];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(syncTasklist:)];
    [syncBtn addGestureRecognizer:recognizer];
    [recognizer release];
    [toolBar addSubview:syncBtn];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolBar]; 
    self.navigationItem.leftBarButtonItem = barButtonItem;
    [barButtonItem release];
    
    [toolBar release];
    
    //设置右选项卡中的按钮
    settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(0, 10, 27, 27);
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog("viewDidLoad事件触发");

    //登录用户进行同步
    [self syncTasklist:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog("viewWillAppear事件触发")
    //如果未登录用户隐藏同步按钮
    syncBtn.hidden = [[ConstantClass instance] username].length == 0;

    [self loadTasklistData];
}

- (void)dealloc
{
    RELEASE(tasklists);
    RELEASE(tasklistTableView);
    RELEASE(tasklistDao);
    RELEASE(taskDao);
    RELEASE(taskIdxDao);
    RELEASE(changeLogDao);
    RELEASE(backBtn);
    RELEASE(editBtn);
    RELEASE(syncBtn);
    RELEASE(settingBtn);
    RELEASE(tasklistService);
    RELEASE(taskService);
    RELEASE(setting_navViewController);
    [super dealloc];
}

# pragma mark - 相关动作事件

- (void) loadTasklistData
{
    NSLog(@"开始初始化任务列表数据");
    
    self.tasklists = [tasklistDao getAllTasklist];
    
    //如果未登录用户并且无列表增加一条默认列表
    if(tasklists.count == 0
       && [[ConstantClass instance] username].length == 0)
    {
        Tasklist *tasklist = [tasklistDao addTasklist:@"0" :@"默认列表" :@"personal"];
        [tasklistDao commitData];
        
        //添加
        [tasklists addObject:tasklist];
    }
    
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
    
    [tasklistTableView reloadData];
}

- (void)syncTasklist:(id)sender
{    
    //登录用户进行同步
    if([[ConstantClass instance] username].length > 0)
    {
        self.HUD = [Tools process:LOADING_TITLE view:self.view];
        
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        [context setObject:@"SyncTasklists" forKey:REQUEST_TYPE];
        if(networkQueue)
        {
            networkQueue = nil;
        }
        networkQueue = [ASINetworkQueue queue];
        [tasklistService syncTasklists:context queue:networkQueue delegate:self];
    }
}

- (void)settingAction:(id)sender
{
    if(setting_navViewController == nil)
    {
        //设置
        SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil setTitle:@"设置" setImage:SETTING_IMAGE];
        
        setting_navViewController = [[BaseNavigationController alloc] initWithRootViewController:settingViewController];
        
        //后退按钮
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBack.frame = CGRectMake(5, 5, 25, 25);
        [btnBack setBackgroundImage:[UIImage imageNamed:BACK_IMAGE] forState:UIControlStateNormal];
        [btnBack addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
        settingViewController.navigationItem.leftBarButtonItem = backButtonItem;
        [self.navigationController presentModalViewController:setting_navViewController animated:YES];
        
        [backButtonItem release];
        [settingViewController release];
    }
    else
    {
        [self.navigationController presentModalViewController:setting_navViewController animated:YES];
    }
}

- (void)backToOption:(id)sender
{
    [Tools layerTransition:self.navigationController.view from:@"left"];
    [self.navigationController popViewControllerAnimated:NO];
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

- (void)send:(NSString *)name
{
    NSString *guid = [Tools stringWithUUID];
    NSString *tasklistId = [NSString stringWithFormat:@"temp_%@", guid];
    
    NSString *tasklistname = name;
    NSString *tasklisttype = @"personal";
    
    [tasklistDao addTasklist:tasklistId :tasklistname :tasklisttype];
    [tasklistDao commitData];
    
    //[editBtn resignFirstResponder];
    
    [self loadTasklistData];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"请求响应数据: %@, %d",request.responseString, request.responseStatusCode);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    NSLog(@"requestType:%@", requestType);
    if([requestType isEqualToString:@"SyncTasks"])
    {
        if(request.responseStatusCode == 200)
        {
            NSString *currentTasklistId = [userInfo objectForKey:@"TasklistId"];
            
            NSMutableArray *array = [[request responseString] JSONValue];
            
            if(array.count > 0)
            {
                for(NSMutableDictionary *dict in array)
                {
                    NSString * oldId = (NSString*)[dict objectForKey:@"OldId"];
                    NSString * newId = (NSString*)[dict objectForKey:@"NewId"];
                    
                    NSLog(@"任务旧值ID: %@ 变为新值ID:%@", oldId, newId);
                    
                    [taskDao updateTaskIdByNewId:oldId newId:newId];
                    [taskIdxDao updateTaskIdxByNewId:oldId newId:newId tasklistId:currentTasklistId];
                }
            }
            
            //修正changeLog
            [changeLogDao deleteChangeLogByTasklistId:currentTasklistId];
            [changeLogDao commitData];
            
//            NSMutableDictionary *context = [NSMutableDictionary dictionary];
//            [context setObject:@"GetTasks" forKey:REQUEST_TYPE];
//            
//            [taskService getTasks:currentTasklistId context:context delegate:self];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"GetTasklists"])
    {
        if(request.responseStatusCode == 200)
        {
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
            
            NSMutableArray *tempTasklists = [tasklistDao getAllTasklist];
            if(tempTasklists.count == 0)
            {
                [Tools close:self.HUD];
            }
            else
            {
                NSMutableDictionary *context = [NSMutableDictionary dictionary];
                [context setObject:@"SyncTasks" forKey:REQUEST_TYPE];
                if(networkQueue)
                {
                    networkQueue = nil;
                }
                networkQueue = [ASINetworkQueue queue];
                [taskService syncTasks:tempTasklists context:context queue:networkQueue delegate:self];
            }
            
            [self loadTasklistData];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"CreateTasklist"])
    {
        if(request.responseStatusCode == 200)
        {
            [Tools close:self.HUD];
            
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
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"GetAllTasks"])
    {
        if(request.responseStatusCode == 200)
        {
            NSString *currentTasklistId = [request.userInfo objectForKey:@"TasklistId"];
            NSDictionary *dict = nil;
            @try
            {
                dict = [[request responseString] JSONValue];
                
                if(dict)
                {
                    NSString *tasklist_editable = [dict objectForKey:@"Editable"];
                    
                    //更新Tasklist的可编辑状态
                    [tasklistDao updateEditable:[NSNumber numberWithInt:[tasklist_editable integerValue]] tasklistId:currentTasklistId];
                    
                    NSArray *tasks = [dict objectForKey:@"List"];
                    NSArray *taskIdxs =[dict objectForKey:@"Sorts"];
                    
                    [taskDao deleteAll:currentTasklistId];
                    [taskIdxDao deleteAllTaskIdx:currentTasklistId];
                    
                    [taskIdxDao commitData];
                    
                    for(NSDictionary *taskDict in tasks)
                    {
                        NSString *taskId = [NSString stringWithFormat:@"%@", (NSString*)[taskDict objectForKey:@"ID"]];
                        
                        NSString* subject = [taskDict objectForKey:@"Subject"] == [NSNull null] ? @"" : [taskDict objectForKey:@"Subject"];
                        NSString *body = [taskDict objectForKey:@"Body"] == [NSNull null] ? @"" : [taskDict objectForKey:@"Body"];
                        NSString *isCompleted = (NSString*)[taskDict objectForKey:@"IsCompleted"];
                        NSNumber *status = [NSNumber numberWithInt:[isCompleted integerValue]];
                        NSString *priority = [NSString stringWithFormat:@"%@", [taskDict objectForKey:@"Priority"]];
                        
                        NSString *editable = (NSString*)[taskDict objectForKey:@"Editable"];
                        
                        
                        NSDate *due = nil;
                        if([taskDict objectForKey:@"DueTime"] != [NSNull null])
                            due = [Tools NSStringToShortNSDate:[taskDict objectForKey:@"DueTime"]];
                        
                        NSString *createDateString = [taskDict objectForKey:@"CreateTime"];
                        NSDate *createDate = nil;
                        if(createDateString != [NSNull null])
                        {
                            createDate = [Tools NSStringToNSDate:createDateString];
                        }
                        else
                        {
                            createDate = [NSDate date];
                        }
                        [taskDao addTask:subject
                              createDate:createDate
                          lastUpdateDate:[NSDate date]
                                    body:body
                                isPublic:[NSNumber numberWithInt:1]
                                  status:status
                                priority:priority
                                  taskid:taskId
                                 dueDate:due
                                editable:[NSNumber numberWithInt:[editable integerValue]]
                              tasklistId:currentTasklistId
                                isCommit:NO];
                    }
                    
                    for(NSDictionary *idxDict in taskIdxs)
                    {
                        NSString *by = (NSString*)[idxDict objectForKey:@"By"];
                        NSString *key = (NSString*)[idxDict objectForKey:@"Key"];
                        NSString *name = (NSString*)[idxDict objectForKey:@"Name"];
                        
                        NSArray *array = (NSArray*)[idxDict objectForKey:@"Indexs"];
                        NSString *indexes = [array JSONRepresentation];
                        
                        [taskIdxDao addTaskIdx:by key:key name:name indexes:indexes tasklistId:currentTasklistId];
                    }
                    
                    [taskIdxDao commitData];
                }
            }
            @catch (NSException *exception)
            {
                NSLog(@"exception message:%@", [exception description]);
                [Tools failed:self.HUD];
            }
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
}
- (void)queueFinished:(ASINetworkQueue *)queue
{
    NSString *requestType = [queue.userInfo objectForKey:REQUEST_TYPE];
    if([requestType isEqualToString:@"SyncTasklists"])
    {
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        [context setObject:@"GetTasklists" forKey:REQUEST_TYPE];
        [tasklistService getTasklists:context delegate:self];
    }
    else if([requestType isEqualToString:@"SyncTasks"])
    {
        if (networkQueue.requestsCount == 0)
        {
            networkQueue = nil;
        }
        NSLog(@"队列运行完成");
        
        [[ConstantClass instance] setSortHasChanged:@""];
        [ConstantClass saveSortHasChangedToCache];
    
        NSMutableArray *tempTasklists = [tasklistDao getAllTasklist];
        if(tempTasklists.count == 0)
        {
            [Tools close:self.HUD];
        }
        else
        {
            NSMutableDictionary *context = [NSMutableDictionary dictionary];
            [context setObject:@"GetAllTasks" forKey:REQUEST_TYPE];
            if(networkQueue)
            {
                networkQueue = nil;
            }
            networkQueue = [ASINetworkQueue queue];
            [taskService getAllTasks:tempTasklists context:context queue:networkQueue delegate:self];
        }
    }
    else if([requestType isEqualToString:@"GetAllTasks"])
    {
        [Tools close:self.HUD];
        
        [self loadTasklistData];
    }
}
- (void)notProcessReturned:(NSMutableDictionary*)userInfo
{
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    if([requestType isEqualToString:@"SyncTasklists"])
    {
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        [context setObject:@"GetTasklists" forKey:REQUEST_TYPE];
        [tasklistService getTasklists:context delegate:self];
    }
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
    TaskController *taskViewController = [[[TaskController alloc] initWithNibName:@"TaskController" 
                                                                                   bundle:nil 
                                                                                 setTitle:@"个人任务" 
                                                                                 setImage:@"task.png"] autorelease];
    taskViewController.currentTasklistId = tasklistId;
    
    //已完成
    TaskController *completeTaskViewController = [[[TaskController alloc] initWithNibName:@"TaskController" 
                                                                                           bundle:nil 
                                                                                         setTitle:@"已完成" 
                                                                                         setImage:@"complete.png"] autorelease];
    completeTaskViewController.filterStatus = @"1";         //完成状态设置为1
    completeTaskViewController.currentTasklistId = tasklistId;
    
    //未完成
    TaskController *incompleteTaskViewController = [[[TaskController alloc] initWithNibName:@"TaskController" 
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
