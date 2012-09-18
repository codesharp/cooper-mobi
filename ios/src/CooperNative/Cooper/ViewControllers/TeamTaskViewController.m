//
//  TeamTaskViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-9-17.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TeamTaskViewController.h"
#import "CustomTabBarController.h"
#import "CustomToolbar.h"

@implementation TeamTaskViewController

@synthesize settingViewController;
@synthesize currentTeamId;
@synthesize taskIdxGroup;
@synthesize taskGroup;

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
    
    teamService = [[TeamService alloc] init];
    teamDao = [[TeamDao alloc] init];
    
    statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 369, [Tools screenMaxWidth], 49)];
    statusView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TABBAR_BG_IMAGE]];
    [self.view addSubview:statusView];
	
    filterLabel = [[UILabel alloc] init];
//    NSString* word = @"Project:Cooper Tag:native hybrid Member:萧玄 侯昆 何望";
//    CGSize size = [word sizeWithFont:filterLabel.font constrainedToSize:CGSizeMake(240, 10000) lineBreakMode:UILineBreakModeWordWrap];
//    CGFloat labelHeight = size.height;
//    NSInteger lines = labelHeight / 16;
//    filterLabel.numberOfLines = lines;
    filterLabel.textColor = [UIColor whiteColor];
    filterLabel.backgroundColor = [UIColor clearColor];
    [statusView addSubview:filterLabel];
    
    settingBtn = [[UIView alloc] initWithFrame:CGRectMake([Tools screenMaxWidth] - 45, 0, 38, 45)];
    UIImageView *backImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 27, 27)] autorelease];
    UIImage *backImage = [UIImage imageNamed:SETTING_IMAGE];
    backImageView.image = backImage;
    [settingBtn addSubview:backImageView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingAction:)];
    [settingBtn addGestureRecognizer:recognizer];
    [recognizer release];
    [statusView addSubview:settingBtn];
    
    CustomToolbar *toolBar = [[[CustomToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 45.0f)] autorelease];
    
    //左边导航编辑按钮
    editBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 45)];
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 27, 27)] autorelease];
    UIImage *editImage = [UIImage imageNamed:@"tasklist.png"];
    imageView.image = editImage;
    [editBtn addSubview:imageView];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    [editBtn addGestureRecognizer:recognizer];
    [recognizer release];
    [toolBar addSubview:editBtn];
    
    if([[ConstantClass instance] username].length > 0)
    {
        //同步按钮
        syncBtn = [[UIView alloc] initWithFrame:CGRectMake(40, 0, 38, 45)];
        UIImageView *settingImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 27, 27)] autorelease];
        UIImage *settingImage = [UIImage imageNamed:REFRESH_IMAGE];
        settingImageView.image = settingImage;
        [syncBtn addSubview:settingImageView];
        UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sync:)];
        [syncBtn addGestureRecognizer:recognizer2];
        [recognizer2 release];
        [toolBar addSubview:syncBtn];
    }
    
    UIBarButtonItem *barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolBar] autorelease];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    CustomToolbar *rightToolBar = [[[CustomToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 45.0f)] autorelease];
    //设置右选项卡中的按钮
    addBtn = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 38, 45)];
    UIImageView *imageView3 = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 27, 27)] autorelease];
    UIImage *editImage3 = [UIImage imageNamed:EDIT_IMAGE];
    imageView3.image = editImage3;
    [addBtn addSubview:imageView3];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTask:)];
    [addBtn addGestureRecognizer:recognizer];
    [recognizer release];
    
    [rightToolBar addSubview:addBtn];
    
    doneEditingBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(5, 10, 50, 30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
    doneEditingBtn.layer.cornerRadius = 6.0f;
    [doneEditingBtn.layer setMasksToBounds:YES];
    [doneEditingBtn addTarget:self action:@selector(doneEditing:) forControlEvents:UIControlEventTouchUpInside];
    [doneEditingBtn setTitle:@"确定" forState:UIControlStateNormal];
    doneEditingBtn.hidden = YES;
    
    [rightToolBar addSubview:doneEditingBtn];
    
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightToolBar];
    
    self.navigationItem.rightBarButtonItem = addButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    Team *team = [teamDao getTeamById:currentTeamId];
    
//    NSString* word = team.name;
//    CGSize size = [word sizeWithFont:filterLabel.font constrainedToSize:CGSizeMake(240, 10000) lineBreakMode:UILineBreakModeWordWrap];
//    CGFloat labelHeight = size.height;
//    NSInteger lines = labelHeight / 16;
//    filterLabel.numberOfLines = lines;
//
//    filterLabel.frame = CGRectMake(5, 5, 280, size.height);
//    filterLabel.text = word;
    
    if(team != nil)
    {
        self.title = team.name;
    }
    
    self.HUD = [Tools process:LOADING_TITLE view:self.view];

    NSMutableDictionary *context = [NSMutableDictionary dictionary];
    [context setObject:@"GetTasks" forKey:REQUEST_TYPE];
    [teamService getTasks:currentTeamId projectId:nil memberId:nil tag:nil context:context delegate:self];
}

- (void)dealloc
{
    [filterLabel release];
    [statusView release];
    [settingViewController release];
    [taskView release];
    [teamService release];
    [teamDao release];
    [editBtn release];
    [syncBtn release];
    [addBtn release];
    [settingBtn release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 动作相关事件

- (void)changeEditing:(id)sender
{
    [taskView setEditing:YES animated:YES];
    
    for(UIGestureRecognizer *r in taskView.gestureRecognizers)
    {
        if([r isKindOfClass:[UILongPressGestureRecognizer class]])
        {
            [taskView removeGestureRecognizer:r];
            break;
        }
    }
    
    addBtn.hidden = YES;
    doneEditingBtn.hidden = NO;
}

- (void)doneEditing:(id)sender
{
    [taskView setEditing:NO animated:YES];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(changeEditing:)];
    [taskView addGestureRecognizer:longPressGesture];
    [longPressGesture release];
    
    addBtn.hidden = NO;
    doneEditingBtn.hidden = YES;
}

- (void)back:(id)sender
{
    [Tools layerTransition:self.navigationController.view from:@"left"];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)settingAction:(id)sender
{
    if(settingViewController == nil)
    {
        settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil]; 
    }
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:settingViewController animated:NO];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"请求任务响应数据: %@, %d", request.responseString, request.responseStatusCode);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    
    if([requestType isEqualToString:@"GetTasks"])
    {
        [Tools close:self.HUD];
        
        if(request.responseStatusCode == 200)
        {
//            NSDictionary *dict = nil;
//            @try
//            {
//                dict = [[request responseString] JSONValue];
//                
//                if(dict)
//                {
//                    NSString *tasklist_editable = [dict objectForKey:@"Editable"];
//                    
//                    //更新Tasklist的可编辑状态
//                    [tasklistDao updateEditable:[NSNumber numberWithInt:[tasklist_editable integerValue]] tasklistId:currentTasklistId];
//                    
//                    if([tasklist_editable integerValue] == 0)
//                    {
//                        addBtn.hidden = YES;
//                    }
//                    else {
//                        addBtn.hidden = NO;
//                    }
//                    
//                    NSArray *tasks = [dict objectForKey:@"List"];
//                    NSArray *taskIdxs =[dict objectForKey:@"Sorts"];
//                    
//                    [taskDao deleteAll:currentTasklistId];
//                    [taskIdxDao deleteAllTaskIdx:currentTasklistId];
//                    
//                    [taskIdxDao commitData];
//                    
//                    for(NSDictionary *taskDict in tasks)
//                    {
//                        NSString *taskId = [NSString stringWithFormat:@"%@", (NSString*)[taskDict objectForKey:@"ID"]];
//                        
//                        NSString* subject = [taskDict objectForKey:@"Subject"] == [NSNull null] ? @"" : [taskDict objectForKey:@"Subject"];
//                        NSString *body = [taskDict objectForKey:@"Body"] == [NSNull null] ? @"" : [taskDict objectForKey:@"Body"];
//                        NSString *isCompleted = (NSString*)[taskDict objectForKey:@"IsCompleted"];
//                        NSNumber *status = [NSNumber numberWithInt:[isCompleted integerValue]];
//                        NSString *priority = [NSString stringWithFormat:@"%@", [taskDict objectForKey:@"Priority"]];
//                        
//                        NSString *editable = (NSString*)[taskDict objectForKey:@"Editable"];
//                        
//                        
//                        NSDate *due = nil;
//                        if([taskDict objectForKey:@"DueTime"] != [NSNull null])
//                            due = [Tools NSStringToShortNSDate:[taskDict objectForKey:@"DueTime"]];
//                        
//                        [taskDao addTask:subject
//                              createDate:[NSDate date]
//                          lastUpdateDate:[NSDate date]
//                                    body:body
//                                isPublic:[NSNumber numberWithInt:1]
//                                  status:status
//                                priority:priority
//                                  taskid:taskId
//                                 dueDate:due
//                                editable:[NSNumber numberWithInt:[editable integerValue]]
//                              tasklistId:currentTasklistId
//                                isCommit:NO];
//                    }
//                    
//                    for(NSDictionary *idxDict in taskIdxs)
//                    {
//                        NSString *by = (NSString*)[idxDict objectForKey:@"By"];
//                        NSString *key = (NSString*)[idxDict objectForKey:@"Key"];
//                        NSString *name = (NSString*)[idxDict objectForKey:@"Name"];
//                        
//                        NSArray *array = (NSArray*)[idxDict objectForKey:@"Indexs"];
//                        NSString *indexes = [array JSONRepresentation];
//                        
//                        [taskIdxDao addTaskIdx:by key:key name:name indexes:indexes tasklistId:currentTasklistId];
//                    }
//                    
//                    [taskIdxDao commitData];
//                    
//                    [self loadTaskData];
//                }
//            }
//            @catch (NSException *exception)
//            {
//                NSLog(@"exception message:%@", [exception description]);
//                [Tools failed:self.HUD];
//            }
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
}

@end
