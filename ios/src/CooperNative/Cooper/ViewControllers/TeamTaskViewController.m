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
#import "SBJsonParser.h"

@implementation TeamTaskViewController

@synthesize settingViewController;
@synthesize teamTaskFilterViewController;
@synthesize teamTaskDetailViewController;

@synthesize currentTeamId;
@synthesize currentProjectId;
@synthesize currentMemberId;
@synthesize currentTag;
@synthesize needSync;

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
    taskDao = [[TaskDao alloc] init];
    taskIdxDao = [[TaskIdxDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
    teamMemberDao = [[TeamMemberDao alloc] init];
    projectDao = [[ProjectDao alloc] init];
    
    statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 369, [Tools screenMaxWidth], 49)];
    statusView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TABBAR_BG_IMAGE]];
    [self.view addSubview:statusView];
	
    filterLabel = [[UILabel alloc] init];
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
        UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forceSync:)];
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
    
    [self initContentView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadTaskData];
    
    Team *team = [teamDao getTeamById:currentTeamId]; 
    if(team != nil)
    {
        self.title = team.name;
    }
    
    [self sync:nil];
}

- (void)dealloc
{
    [filterLabel release];
    [statusView release];
    [settingViewController release];
    [teamTaskFilterViewController release];
    [teamTaskDetailViewController release];
    [taskView release];
    [teamService release];
    [teamDao release];
    [taskIdxDao release];
    [taskDao release];
    [changeLogDao release];
    [commentDao release];
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

#pragma mark - Table view 数据源

//获取TableView的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([[self taskIdxGroup] count] == 0)
        return 0;
    return self.taskIdxGroup.count;
}
//获取在制定的分区编号下的纪录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.taskGroup count] == 0)
        return 0;
    return [[self.taskGroup objectAtIndex:section] count];
}
//填充单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaskTableViewCell";
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
	{
        cell = [[TaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    Task *task = [[self.taskGroup objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setTaskInfo:task];
    cell.delegate = self;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //cell.editingAccessoryType = UITableViewCellEditingStyleDelete;
    cell.showsReorderControl = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
    selectedView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
    cell.backgroundColor = [UIColor whiteColor];
    
    //设置选中后cell的背景颜色
    cell.selectedBackgroundView = selectedView;
    
    return cell;
}

- (void)moveTableView:(UITableView *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *task = [[self.taskGroup objectAtIndex:fromIndexPath.section] objectAtIndex:fromIndexPath.row];
    
    if(fromIndexPath.section == toIndexPath.section)
    {
        [[self.taskGroup objectAtIndex:fromIndexPath.section] removeObjectAtIndex:fromIndexPath.row];
        [[self.taskGroup objectAtIndex:toIndexPath.section] insertObject:task atIndex:toIndexPath.row];
    }
    else {
        [[self.taskGroup objectAtIndex:fromIndexPath.section] removeObjectAtIndex:fromIndexPath.row];
        [[self.taskGroup objectAtIndex:toIndexPath.section] insertObject:task atIndex:toIndexPath.row];
    }
    
    NSLog(@"fromIndexPath.section-row:%d-%d,toIndexPath.section-row:%d-%d",fromIndexPath.section, fromIndexPath.row, toIndexPath.section, toIndexPath.row);
}

- (NSIndexPath *)moveTableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	if ([sourceIndexPath section] != [proposedDestinationIndexPath section]) {
		proposedDestinationIndexPath = sourceIndexPath;
	}
	
	return proposedDestinationIndexPath;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"手指撮动了");
    return UITableViewCellEditingStyleDelete;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES animated:YES];
    
    return indexPath;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *titleLabel = [[[UILabel alloc]init]autorelease];
    titleLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sectionTitlebg.png"]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [titleLabel setTextColor:[UIColor grayColor]];
    
    if(section == 0)
        titleLabel.text = [NSString stringWithFormat:@"  %@", PRIORITY_TITLE_1];
    else if(section == 1)
        titleLabel.text = [NSString stringWithFormat:@"  %@", PRIORITY_TITLE_2];
    else if(section == 2)
        titleLabel.text = [NSString stringWithFormat:@"  %@", PRIORITY_TITLE_3];
    
    return titleLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self loadTaskData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = (UITableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
	return cell.frame.size.height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//点击右侧箭号
- (void) tableView:(UITableView*)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}

//点击标准编辑按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Task *t = [[self.taskGroup objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if(t.editable == [NSNumber numberWithInt:0])
        {
            [Tools msg:@"该任务无法删除" HUD:self.HUD];
            return;
        }
        
        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:1]
                                     dataId:t.id
                                       name:@""
                                      value:@""
                                     teamId:currentTeamId
                                  projectId:currentProjectId
                                   memberId:currentMemberId
                                        tag:currentTag];
        [taskIdxDao deleteTaskIndexsByTaskIdAndTeam:t.id teamId:currentTeamId projectId:currentProjectId memberId:currentMemberId tag:currentTag];
        [taskDao deleteTask:t];
        
        [taskDao commitData];
        [t release];
        
        [[self.taskGroup objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
//    if(filterStatus == nil)
//    {
//        NSMutableArray *sourceArray = [self.taskGroup objectAtIndex:sourceIndexPath.section];
//        NSMutableArray *destArray = [self.taskGroup objectAtIndex:destinationIndexPath.section];
//        Task *task = [sourceArray objectAtIndex:sourceIndexPath.row];
//        [sourceArray removeObjectAtIndex:sourceIndexPath.row];
//        [destArray insertObject:task atIndex:destinationIndexPath.row];
//        
//        TaskIdx *sTaskIdx = [self.taskIdxGroup objectAtIndex:sourceIndexPath.section];
//        TaskIdx *dTaskIdx = [self.taskIdxGroup objectAtIndex:destinationIndexPath.section];
//        
//        task.priority = dTaskIdx.key;
//        if(sTaskIdx != dTaskIdx)
//        {
//            NSLog(@"sTaskIdx != dTaskIdx");
//            [changeLogDao insertChangeLog:[NSNumber numberWithInt:0]
//                                   dataid:task.id
//                                     name:@"priority"
//                                    value:task.priority
//                               tasklistId:currentTasklistId];
//        }
//        NSLog(@"sourceIndexPath:%d, toIndexPath:%d", sourceIndexPath.row, destinationIndexPath.row);
//        
//        [taskIdxDao adjustIndex:task.id
//                  sourceTaskIdx: sTaskIdx
//             destinationTaskIdx: dTaskIdx
//                 sourceIndexRow:[NSNumber numberWithInteger:sourceIndexPath.row]
//                   destIndexRow:[NSNumber numberWithInteger:destinationIndexPath.row]
//                     tasklistId:currentTasklistId];
//        [taskDao commitData];
//        
//        [[ConstantClass instance] setSortHasChanged:@"true"];
//        [ConstantClass saveSortHasChangedToCache];
//    }
}
//分区标题输出
- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return [NSString stringWithFormat:@"  %@", PRIORITY_TITLE_1];
    else if(section == 1)
        return [NSString stringWithFormat:@"  %@", PRIORITY_TITLE_2];
    else if(section == 2)
        return [NSString stringWithFormat:@"  %@", PRIORITY_TITLE_3];
    
    return @"";
}

- (void) didSelectCell:(Task*)task
{
//    TaskDetailViewController *detailController = [[[TaskDetailViewController alloc] init] autorelease];
//    detailController.task = task;
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:detailController];
//    if(MODEL_VERSION >= 5.0)
//    {
//        [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE] forBarMetrics:UIBarMetricsDefault];
//    }
//    else {
//        UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE]] autorelease];
//        [imageView setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], 44)];
//        [navigationController.navigationBar addSubview:imageView];
//    }
//    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    
//    [self.navigationController presentModalViewController:navigationController animated:YES];
}

//点击单元格事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (teamTaskDetailViewController == nil) {
        teamTaskDetailViewController = [[TeamTaskDetailViewController alloc] init];
    }
    Task *task = [[self.taskGroup objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    teamTaskDetailViewController.task = task;
    //taskDetailViewController.currentTasklistId = currentTasklistId;
    
    //[teamTaskDetailViewController setHidesBottomBarWhenPushed:YES];
    //taskDetailViewController.delegate = self;
    
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:teamTaskDetailViewController animated:NO];
}

#pragma mark - 动作相关事件

- (void)initContentView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect tableViewRect = CGRectMake(0, 0, [Tools screenMaxWidth], [Tools screenMaxHeight] - 49 - 64);
    UITableView* tempTableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    [tempTableView setBackgroundColor:[UIColor whiteColor]];
    
    //去掉底部空白
    UIView *footer =
    [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    tempTableView.tableFooterView = footer;
    
    taskView = tempTableView;
    taskView.delegate = self;
    taskView.dataSource = self;
    
//    if(filterStatus == nil && (![currentTasklistId isEqualToString:@"ifree"]
//                               && ![currentTasklistId isEqualToString:@"wf"]
//                               && ![currentTasklistId isEqualToString:@"github"]))
//    {
//        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(changeEditing:)];
//        [taskView addGestureRecognizer:longPressGesture];
//        [longPressGesture release];
//    }
    
    [self.view addSubview: taskView];
    [tempTableView release];
}

- (void)loadTaskData
{
    NSLog(@"开始初始化任务数据");
    
    self.taskIdxGroup = [NSMutableArray array];
    self.taskGroup = [NSMutableArray array];
    
    NSMutableArray *taskIdxs = [taskIdxDao getAllTaskIdxByTeam:currentTeamId
                                                     projectId:currentProjectId
                                                      memberId:currentMemberId
                                                           tag:currentTag];

    SBJsonParser *parser = [[SBJsonParser alloc] init];
    for(TaskIdx *taskIdx in taskIdxs)
    {
        if([taskIdx.indexes isEqualToString:@"[]"])
            continue;
        
        NSMutableArray *task_array = [NSMutableArray array];
        
        [self.taskIdxGroup addObject:taskIdx];
        
        NSMutableArray *taskIdsDict = [parser objectWithString:taskIdx.indexes];
        
        for(NSString *taskId in taskIdsDict)
        {
            Task *task = [taskDao getTaskById:taskId]; 
            [task_array addObject:task];
        }
        [taskGroup addObject:task_array];
    }
    
    [parser release];
    
    [taskView reloadData];
    
//    if(taskGroup.count == 0)
//    {
//        taskView.hidden = YES;
//        
//        if (!emptyView)
//        {
//            if([currentTasklistId isEqualToString:@"ifree"]
//               || [currentTasklistId isEqualToString:@"github"]
//               || [currentTasklistId isEqualToString:@"wf"])
//            {
//                UIView *tempemptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, [Tools screenMaxWidth], 100)];
//                tempemptyView.backgroundColor = [UIColor whiteColor];
//                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80 + (([Tools screenMaxWidth] - 320) / 2.0), 0, 200, 30)];
//                label.text = @"当前任务列表无法编辑";
//                label.font = [UIFont boldSystemFontOfSize:16];
//                //label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
//                [tempemptyView addSubview:label];
//                emptyView = tempemptyView;
//                [self.view addSubview:emptyView];
//                [tempemptyView release];
//            }
//            else
//            {
//                UIView *tempemptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, [Tools screenMaxWidth], 100)];
//                tempemptyView.backgroundColor = [UIColor whiteColor];
//                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80 + (([Tools screenMaxWidth] - 320) / 2.0), 0, 200, 30)];
//                label.text = @"点击这里新增第一个任务";
//                label.font = [UIFont boldSystemFontOfSize:16];
//                //label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
//                [tempemptyView addSubview:label];
//                
//                CustomButton *addFirstBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(110 + (([Tools screenMaxWidth] - 320) / 2.0), 50,100,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
//                addFirstBtn.layer.cornerRadius = 6.0f;
//                [addFirstBtn.layer setMasksToBounds:YES];
//                [addFirstBtn addTarget:self action:@selector(addTask:) forControlEvents:UIControlEventTouchUpInside];
//                [addFirstBtn setTitle:@"开始添加" forState:UIControlStateNormal];
//                [tempemptyView addSubview:addFirstBtn];
//                emptyView = tempemptyView;
//                [self.view addSubview:emptyView];
//                
//                [tempemptyView release];
//            }
//        }
//        else
//        {
//            emptyView.hidden = NO;
//        }
//    }
//    else {
//        taskView.hidden = NO;
//        emptyView.hidden = YES;
//    }
}

- (void)forceSync:(id)sender
{
    self.needSync = YES;
    [self sync:sender];
}

//同步任务
- (void)sync:(id)sender
{
    if(self.needSync == YES)
    {
        self.HUD = [Tools process:LOADING_TITLE view:self.view];
        
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        [context setObject:@"SyncTasks" forKey:REQUEST_TYPE];
        [teamService syncTasks:currentTeamId
                     projectId:currentProjectId
                      memberId:currentMemberId
                           tag:currentTag
                       context:context delegate:self];
        
        self.needSync = NO;
    }
}

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
    if(teamTaskFilterViewController == nil)
    {
        teamTaskFilterViewController = [[TeamTaskFilterViewController alloc] init];
    }
    
    teamTaskFilterViewController.currentTeamId = currentTeamId;
    teamTaskFilterViewController.delegate = self;
    
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView setAnimationDuration:0.7];
    [UIView commitAnimations];
    
    [self.navigationController pushViewController:teamTaskFilterViewController animated:NO];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"请求任务响应数据: %@, %d", request.responseString, request.responseStatusCode);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    
    if([requestType isEqualToString:@"SyncTasks"])
    {
        if(request.responseStatusCode == 200)
        {
            NSMutableArray *array = [[request responseString] JSONValue];
            
            if(array.count > 0)
            {
                for(NSMutableDictionary *dict in array)
                {
                    NSString * oldId = (NSString*)[dict objectForKey:@"OldId"];
                    NSString * newId = (NSString*)[dict objectForKey:@"NewId"];
                    
                    NSLog(@"任务旧值ID: %@ 变为新值ID:%@", oldId, newId);
                    
                    [taskDao updateTaskIdByNewId:oldId newId:newId];
                    [taskIdxDao updateTaskIdxByNewIdAndTeam:oldId
                                                      newId:newId
                                                     teamId:currentTeamId
                                                  projectId:currentProjectId
                                                   memberId:currentMemberId
                                                        tag:currentTag];
                    //修改changelog的oldId
                    [changeLogDao updateTaskIdByNewId:oldId newId:newId];
                }
            }
            
            //修正changeLog
            [changeLogDao deleteChangeLogByTeam:currentTeamId projectId:currentProjectId memberId:currentMemberId tag:currentTag];
            [changeLogDao commitData];
            
            NSMutableDictionary *context = [NSMutableDictionary dictionary];
            [context setObject:@"GetTasks" forKey:REQUEST_TYPE];
            [teamService getTasks:currentTeamId
                        projectId:currentProjectId
                         memberId:currentMemberId
                              tag:currentTag
                          context:context
                         delegate:self];
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
    else if([requestType isEqualToString:@"GetTasks"])
    {
        [Tools close:self.HUD];
        
        if(request.responseStatusCode == 200)
        {
            NSDictionary *dict = [[request responseString] JSONValue];        
            if(dict)
            {
//                NSString *team_editable = [dict objectForKey:@"Editable"];
                
//                //TODO:更新Team的可编辑状态
//                [teamDao updateEditable:[NSNumber numberWithInt:[team_editable integerValue]] teamId:currentTeamId];
//
//                if([team_editable integerValue] == 0)
//                {
//                    addBtn.hidden = YES;
//                }
//                else {
//                    addBtn.hidden = NO;
//                }
                
                NSArray *tasks = [dict objectForKey:@"List"];
                NSArray *taskIdxs =[dict objectForKey:@"Sorts"];
                
                [taskDao deleteAllByTeam:currentTeamId];
                [taskIdxDao deleteAllByTeam:currentTeamId projectId:currentProjectId memberId:currentMemberId tag:currentTag]; 
                
                [taskIdxDao commitData];
                
                for(NSDictionary *taskDict in tasks)
                {
                    NSString *taskId = [taskDict objectForKey:@"ID"];
                    
                    NSString* subject = [taskDict objectForKey:@"Subject"] == [NSNull null] ? @"" : [taskDict objectForKey:@"Subject"];
                    NSString *body = [taskDict objectForKey:@"Body"] == [NSNull null] ? @"" : [taskDict objectForKey:@"Body"];
                    NSString *isCompleted = (NSString*)[taskDict objectForKey:@"IsCompleted"];
                    NSNumber *status = [NSNumber numberWithInt:[isCompleted integerValue]];
                    NSString *priority = [NSString stringWithFormat:@"%@", [taskDict objectForKey:@"Priority"]];
                    
                    NSString *editable = (NSString*)[taskDict objectForKey:@"Editable"];
   
                    NSDate *due = nil;
                    if([taskDict objectForKey:@"DueTime"] != [NSNull null])
                        due = [Tools NSStringToShortNSDate:[taskDict objectForKey:@"DueTime"]];
                    
                    NSMutableDictionary *creatorDict = [taskDict objectForKey:@"Creator"];
                    NSString *createMemberId = [creatorDict objectForKey:@"id"];
                    
                    NSString *assigneeId = nil;
                    NSMutableDictionary *assigneeDict = [taskDict objectForKey:@"Assignee"];
                    if(assigneeDict != [NSNull null])
                    {
                        assigneeId = [assigneeDict objectForKey:@"id"];
                    }
                    
                    NSMutableArray *projectsArray = [taskDict objectForKey:@"Projects"];
                    NSString *projects = [projectsArray JSONRepresentation];
                    
                    NSMutableArray *tagsArray = [taskDict objectForKey:@"Tags"];
                    NSString *tags = [tagsArray JSONRepresentation];

//                    NSMutableArray *commentsArray = [taskDict objectForKey:@"Comments"];
//                    for (NSMutableDictionary *commentDict in commentsArray)
//                    {
//                        NSMutableDictionary *comment_creatorDict = [commentDict objectForKey:@"creator"];
//                        NSString *comment_creatorId = [comment_creatorDict objectForKey:@"id"];
//                        NSString *comment_createTimeString = [commentDict objectForKey:@"createTime"];
//                        NSString *comment_body = [commentDict objectForKey:@"body"];
//                        [commentDao addComment:taskId creatorId:comment_creatorId createTime:comment_createTimeString body:comment_body];
//                    }
                    
                    [taskDao addTeamTask:subject
                          createDate:[NSDate date]
                      lastUpdateDate:[NSDate date]
                                body:body
                            isPublic:[NSNumber numberWithInt:1]
                              status:status
                            priority:priority
                              taskId:taskId
                             dueDate:due
                                editable:[NSNumber numberWithInt:[editable integerValue]]
                          createMemberId:createMemberId
                              assigneeId:assigneeId
                                projects:projects
                                    tags:tags
                                  teamId:currentTeamId];
                }
                
                for(NSDictionary *idxDict in taskIdxs)
                {
                    NSString *by = (NSString*)[idxDict objectForKey:@"By"];
                    NSString *key = (NSString*)[idxDict objectForKey:@"Key"];
                    NSString *name = (NSString*)[idxDict objectForKey:@"Name"];
                    
                    NSArray *array = (NSArray*)[idxDict objectForKey:@"Indexs"];
                    NSString *indexes = [array JSONRepresentation];
                    
                    [taskIdxDao addTeamTaskIdx:by
                                           key:key
                                          name:name
                                       indexes:indexes
                                        teamId:currentTeamId
                                     projectId:currentProjectId
                                      memberId:currentMemberId
                                           tag:currentTag];
                }
                
                [taskIdxDao commitData];
                
                [self loadTaskData];
            }
        }
        else
        {
            [Tools failed:self.HUD];
        }
    }
}

#pragma mark - TaskTaskViewDelegate相关委托方法

- (void)startSync:(NSString*)teamId
        projectId:(NSString*)projectId
         memberId:(NSString*)memberId
              tag:(NSString*)tag
{
    currentTeamId = teamId;
    currentProjectId = projectId;
    currentMemberId = memberId;
    currentTag = tag;
    
    [self showStatusBarText];
    
    self.needSync = YES;
    [self sync:nil];
}

- (void)showStatusBarText
{
    NSString *word = @"";
    if(currentProjectId != nil)
    {
        Project *project = [projectDao getProjectByTeamId:currentTeamId projectId:currentProjectId];
        if(project != nil)
        {
            word = [NSString stringWithFormat:@"Project: %@", project.name];
        }
    }
    else if(currentMemberId != nil)
    {
        TeamMember *teamMember = [teamMemberDao getTeamMemberByTeamId:currentTeamId assigneeId:currentMemberId];
        if(teamMember != nil)
        {
            word = [NSString stringWithFormat:@"Member: %@", teamMember.name];
        }
    }
    else if(currentTag != nil)
    {
        Tag *tag = [tagDao getTagByTeamId:currentTeamId tag:currentTag];
        if(tag != nil)
        {
            word = [NSString stringWithFormat:@"Tag: %@", tag.name];
        }
    }
    CGSize size = [word sizeWithFont:filterLabel.font constrainedToSize:CGSizeMake(240, 10000) lineBreakMode:UILineBreakModeWordWrap];
    CGFloat labelHeight = size.height;
    NSInteger lines = labelHeight / 16;
    filterLabel.numberOfLines = lines;
    filterLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    filterLabel.frame = CGRectMake(5, lines * 5 + 5, 280, size.height);
    filterLabel.text = word;
}

@end
