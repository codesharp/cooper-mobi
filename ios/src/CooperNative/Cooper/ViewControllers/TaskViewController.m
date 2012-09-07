//
//  TaskViewController.m
//  Cooper
//
//  Created by sunleepy on 12-6-29.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskViewController.h"
#import "SBJsonParser.h"
#import "CooperCore/TaskIdx.h"
#import "CustomTabBarController.h"
#import "CustomToolbar.h"
#import "TaskDetailViewController.h"
#import "TaskDetailEditViewController.h"


@implementation TaskViewController

@synthesize taskIdxGroup;
@synthesize taskGroup;
@synthesize filterStatus;
@synthesize currentTasklistId;

#pragma mark - 页面生命周期

- (void)loadView
{
    [super loadView];
    
//    if(taskGroup.count == 0)
//    {
//        //self.tableView.hidden = YES;
//
////        UIView *tempemptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 100)];
////        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 200, 30)];
////        label.text = @"您还没有任务任务记录";
////        label.font = [UIFont boldSystemFontOfSize:16];
////        //label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
////        [tempemptyView addSubview:label];
////        CustomButton *addFirstBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(110,50,100,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
////        addFirstBtn.layer.cornerRadius = 6.0f;
////        [addFirstBtn.layer setMasksToBounds:YES];
////        [addFirstBtn addTarget:self action:@selector(addTask:) forControlEvents:UIControlEventTouchUpInside];
////        [addFirstBtn setTitle:@"开始添加" forState:UIControlStateNormal];
////        [tempemptyView addSubview:addFirstBtn];
////        emptyView.tag = 130;
////        emptyView = tempemptyView;
////        [self.view addSubview:emptyView];
////        [tempemptyView release];
//        
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
//        [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//        
//        self.tableView.tableHeaderView = backBtn;
//    }
//    else {
//        
//    }
}

//初始化
- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
             setTitle:(NSString *)title 
             setImage:(NSString*)imageName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = APP_TITLE;
        //底部条
        CustomTabBarItem *tabBarItem = [[CustomTabBarItem alloc] init];
        [tabBarItem setTitle:title];
        [tabBarItem setCustomImage:[UIImage imageNamed:imageName]];
        self.tabBarItem = tabBarItem;    
        [tabBarItem release];
        
        //self.tableView = [[MoveTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    CustomToolbar *toolBar = [[[CustomToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 45.0f)] autorelease];
    
    //左边导航编辑按钮
    editBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 45)];
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 27, 27)] autorelease];
    UIImage *editImage = [UIImage imageNamed:@"tasklist.png"];
    imageView.image = editImage;
    [editBtn addSubview:imageView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
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
    self.tabBarController.navigationItem.leftBarButtonItem = barButtonItem;
    
    //设置右选项卡中的按钮
    addBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 45)];
    UIImageView *imageView3 = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 27, 27)] autorelease];
    UIImage *editImage3 = [UIImage imageNamed:EDIT_IMAGE];
    imageView3.image = editImage3;
    [addBtn addSubview:imageView3];
    UITapGestureRecognizer *recognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTask:)];
    [addBtn addGestureRecognizer:recognizer3];
    [recognizer3 release];
    
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    
    self.tabBarController.navigationItem.rightBarButtonItem = addButtonItem; 

    self.tableView.backgroundColor = [UIColor whiteColor];
    
//    NSThread* myThread = [[NSThread alloc] initWithTarget:self
//                                                 selector:@selector(loadTaskData)
//                                                   object:nil];
//    [myThread start];
//    [myThread release];
    
    [self loadTaskData];
    
    Tasklist *tasklist = [tasklistDao getTasklistById:currentTasklistId];
    
    self.tabBarController.title = tasklist.name;
}

- (void)viewWillDisappear:(BOOL)animated
{
    //RELEASE(addBtn);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //去掉底部空白
    [Tools clearFootBlank:self.tableView];
    
    taskDao = [[TaskDao alloc] init];
    taskIdxDao = [[TaskIdxDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
    tasklistDao = [[TasklistDao alloc] init]; 

    NSLog(@"f:%@",currentTasklistId)
    [self sync:nil];
}

- (void)dealloc
{
    [taskDao release];
    [taskIdxDao release];
    [changeLogDao release];
    [taskGroup release];
    [taskIdxGroup release];
    [addBtn release];
    [syncBtn release];
    [editBtn release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 动作相关事件

- (void)back:(id)sender
{
    [Tools layerTransition:self.navigationController.view from:@"left"];   
    [self.tabBarController.navigationController popViewControllerAnimated:NO];
}

- (void)sync:(id)sender
{
    if(![currentTasklistId isEqualToString:@"ifree"] 
       && ![currentTasklistId isEqualToString:@"wf"]
       && ![currentTasklistId isEqualToString:@"github"])
        [self syncAction:nil];
    else {
        [self getTasksAction:nil];
    }
}

- (void)syncAction:(id)sender
{
    NSLog(@"开始同步任务数据");
    
    if([[ConstantClass instance] username].length > 0)       
    {
        [self addHUD:LOADING_TITLE];
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        [context setObject:@"SyncTask" forKey:REQUEST_TYPE];
        [TaskService syncTask:currentTasklistId context:context delegate:self];
    }
}

- (void)getTasksAction:(id)sender
{
    NSLog(@"开始加载任务数据");
    
    if([[ConstantClass instance] username].length > 0)       
    {
        [self addHUD:LOADING_TITLE];
        
        NSMutableDictionary *context = [NSMutableDictionary dictionary];
        [context setObject:@"GetTasks" forKey:REQUEST_TYPE];
        editBtn.hidden = YES;
        [TaskService getTasks:currentTasklistId context:context delegate:self];
    }
}

- (void)addRequstToPool:(ASIHTTPRequest *)request {
    //    [requestPool addObject:request];
    NSLog(@"发送请求URL：%@",request.url);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"请求任务响应数据: %@, %d", request.responseString, request.responseStatusCode);

    NSDictionary *userInfo = request.userInfo;
    NSString *requestType = [userInfo objectForKey:REQUEST_TYPE];
    
    if([requestType isEqualToString:@"SyncTask"])
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
                    
                    [taskDao updateTaskIdByNewId:oldId newId:newId tasklistId:currentTasklistId];
                    [taskIdxDao updateTaskIdxByNewId:oldId newId:newId tasklistId:currentTasklistId];
                }
            }
            
            //修正changeLog
            [changeLogDao updateAllToSend:currentTasklistId];
            [changeLogDao commitData];
            
            NSMutableDictionary *context = [NSMutableDictionary dictionary];
            [context setObject:@"GetTasks" forKey:REQUEST_TYPE];
            [TaskService getTasks:currentTasklistId context:context delegate:self];
        }
        else
        {
            [Tools failed:HUD];
        }
    }
    else if([requestType isEqualToString:@"GetTasks"])
    {
        [self HUDCompleted];

        if(request.responseStatusCode == 200)
        {
            NSDictionary *dict = nil;
            @try
            {
                dict = [[request responseString] JSONValue];
                
                if(dict)
                {
                    NSString *tasklist_editable = [dict objectForKey:@"Editable"];
                    
                    //更新Tasklist的可编辑状态
                    [tasklistDao updateEditable:[NSNumber numberWithInt:[tasklist_editable integerValue]] tasklistId:currentTasklistId];
                    
                    if([tasklist_editable integerValue] == 0)
                    {
                        addBtn.hidden = YES;
                    }
                    else {
                        addBtn.hidden = NO;
                    }
                    
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
                        
                        [taskDao addTask:subject
                              createDate:[NSDate date]
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
                    
                    [self loadTaskData];
                }
            }
            @catch (NSException *exception)
            {
                NSLog(@"exception message:%@", [exception description]);
                [Tools failed:HUD];
            }
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
    [Tools msg:NOT_NETWORK_MESSAGE HUD:HUD];
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
    
//    static NSString *cellIdentifier = @"MoveCell";
//	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//	
//	if(!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    
////    if ([tableView indexPathIsMovingIndexPath:indexPath]) 
////	{
////        cell.textLabel.text = @"";
////	}
////	else 
////	{
//		Task *task = [[self.taskGroup objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//        cell.textLabel.text = task.subject;
//		[cell setShouldIndentWhileEditing:NO];
//		[cell setShowsReorderControl:NO];
////	}
//    return cell;
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

//-(NSIndexPath*)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
//{
//    NSDictionary *section = [self.taskGroup objectAtIndex:sourceIndexPath.section];
//    NSUInteger sectionCount = [[section valueForKey:@"content"] count];
//    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
//        NSUInteger rowInSourceSection =
//        (sourceIndexPath.section > proposedDestinationIndexPath.section) ?
//        0 : sectionCount - 1;
//        return [NSIndexPath indexPathForRow:rowInSourceSection inSection:sourceIndexPath.section];
//    } else if (proposedDestinationIndexPath.row >= sectionCount) {
//        return [NSIndexPath indexPathForRow:sectionCount - 1 inSection:sourceIndexPath.section];
//    }
//    // Allow the proposed destination.
//    return proposedDestinationIndexPath;
//}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"手指撮动了");
    return UITableViewCellEditingStyleDelete;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Task *task = [[self.taskGroup objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:YES animated:YES];
    
    return indexPath;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *titleLabel = [[[UILabel alloc]init]autorelease];
    titleLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sectionTitlebg.png"]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [titleLabel setTextColor:[UIColor grayColor]];
    
    //int count = [[self.taskGroup objectAtIndex:section] count];
    //TODO:...
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
    //[self.tableView reloadData];
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Task *t = [[self.taskGroup objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if(t.editable == [NSNumber numberWithInt:0])
        {
            [Tools msg:@"该任务无法删除" HUD:HUD];
            return;
        }
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:1] 
                               dataid:t.id 
                                 name:@"" 
                                value:@""
                           tasklistId:currentTasklistId];      
        [taskIdxDao deleteTaskIndexsByTaskId:t.id
                                  tasklistId:currentTasklistId];      
        [taskDao deleteTask:t];
        
        [taskDao commitData];
        [t release];
        
        [[self.taskGroup objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];        
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view

    }   else {

    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSLog(@"moving");
    if(filterStatus == nil)
    {
        NSMutableArray *sourceArray = [self.taskGroup objectAtIndex:sourceIndexPath.section];
        NSMutableArray *destArray = [self.taskGroup objectAtIndex:destinationIndexPath.section];
        Task *task = [sourceArray objectAtIndex:sourceIndexPath.row];
        [sourceArray removeObjectAtIndex:sourceIndexPath.row];
        [destArray insertObject:task atIndex:destinationIndexPath.row];
        
        TaskIdx *sTaskIdx = [self.taskIdxGroup objectAtIndex:sourceIndexPath.section];
        TaskIdx *dTaskIdx = [self.taskIdxGroup objectAtIndex:destinationIndexPath.section];
        
        task.priority = dTaskIdx.key;
        if(sTaskIdx != dTaskIdx)
        {
            NSLog(@"sTaskIdx != dTaskIdx");
            [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] 
                                   dataid:task.id 
                                     name:@"priority" 
                                    value:task.priority 
                               tasklistId:currentTasklistId];
        } 
        NSLog(@"sourceIndexPath:%d, toIndexPath:%d", sourceIndexPath.row, destinationIndexPath.row);
        
        [taskIdxDao adjustIndex:task.id 
                  sourceTaskIdx: sTaskIdx 
             destinationTaskIdx: dTaskIdx 
                 sourceIndexRow:[NSNumber numberWithInteger:sourceIndexPath.row]
                   destIndexRow:[NSNumber numberWithInteger:destinationIndexPath.row]
                     tasklistId:currentTasklistId];
        [taskDao commitData];
    }
}
//分区标题输出
- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{ 
    //int count = [[self.taskGroup objectAtIndex:section] count];
    //TODO:...
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
    TaskDetailViewController *detailController = [[[TaskDetailViewController alloc] init] autorelease];
    detailController.task = task;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:detailController];
    if(MODEL_VERSION >= 5.0)
    {
        [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE] forBarMetrics:UIBarMetricsDefault];
    }
    else {
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE]] autorelease];
        [imageView setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], 44)];
        [navigationController.navigationBar addSubview:imageView];
    }
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [self.navigationController presentModalViewController:navigationController animated:YES];
}

//点击单元格事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TaskDetailViewController *detailController = [[[TaskDetailViewController alloc] init] autorelease];
    Task *task = [[self.taskGroup objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//    if(task.editable == [NSNumber numberWithInt:0])
//    {
//        [Tools msg:@"该任务无法编辑" HUD:HUD];
//        return;
//    }
    detailController.task = task;
    detailController.currentTasklistId = currentTasklistId;
    
    [detailController setHidesBottomBarWhenPushed:YES];
    detailController.delegate = self;
    
    [Tools layerTransition:self.navigationController.view from:@"right"]; 
    [self.navigationController pushViewController:detailController animated:NO];
}
//过滤搜索事件
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
//    [self.filteredtaskGroup removeAllObjects];
//    
//    for(NSMutableArray *array in self.taskGroup)
//    {
//        for(Task *task in array)
//        {
//            NSComparisonResult result = [task.subject compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
//            if (result == NSOrderedSame)
//			{
//				[self.filteredtaskGroup addObject:task];
//            }
//        }
//    }
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self filterContentForSearchText:searchString scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//
//    return YES;
//}

//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//{
//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
//    
//    // Return YES to cause the search result table view to be reloaded.
//    NSLog(@"shouldReloadTableForSearchScope");
//    return YES;
//}

- (void)loadTaskData
{
    NSLog(@"开始初始化任务数据");
    
    self.taskIdxGroup = [NSMutableArray array];
    self.taskGroup = [NSMutableArray array];
    
    Tasklist *tasklist = [tasklistDao getTasklistById:currentTasklistId];
    if(tasklist.editable == [NSNumber numberWithInt:0])
    {
        addBtn.hidden = YES;
    }
    else {
        addBtn.hidden = NO;
    }
        
    NSMutableArray *taskIdxs = [taskIdxDao getAllTaskIdx:currentTasklistId];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    for(TaskIdx *taskIdx in taskIdxs)
    {
//        if([taskIdx.indexes isEqualToString:@"[]"])
//            continue;
        
        NSMutableArray *task_array = [NSMutableArray array];
        
        [self.taskIdxGroup addObject:taskIdx];
 
        NSMutableArray *taskIdsDict = [parser objectWithString:taskIdx.indexes];

        for(NSString *taskId in taskIdsDict)
        { 
            Task *task = [taskDao getTaskById:taskId];

            if(filterStatus && [filterStatus isEqualToString: [Tools NSNumberToString:task.status]])
            {          
                [task_array addObject:task];
            }    
            if(filterStatus == nil)
                [task_array addObject:task];
        }
        
        [taskGroup addObject:task_array];
    }
    
    [parser release];

    [self.tableView reloadData];
    
//    UIView *temp = nil;
//    for (UIView *anImage in [self.tableView subviews]) {
//        if (anImage.tag == 130) {
//            // do something
//            temp = [self.tableView viewWithTag:130];
//        }
//    } 
//    if(temp != nil)
//    [temp removeFromSuperview];
    
    
    if(taskGroup.count == 0)
    {
        //self.tableView.hidden = YES;
        
//        UIView *tempemptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 100)];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 200, 30)];
//        label.text = @"您还没有任务任务记录";
//        label.font = [UIFont boldSystemFontOfSize:16];
//        //label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
//        [tempemptyView addSubview:label];
//        
//        CustomButton *addFirstBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(110,50,100,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
//        addFirstBtn.layer.cornerRadius = 6.0f;
//        [addFirstBtn.layer setMasksToBounds:YES];
//        [addFirstBtn addTarget:self action:@selector(addTask:) forControlEvents:UIControlEventTouchUpInside];
//        [addFirstBtn setTitle:@"开始添加" forState:UIControlStateNormal];
//        [tempemptyView addSubview:addFirstBtn];
//        emptyView.tag = 130;
//        emptyView = tempemptyView;
//        [self.tableView addSubview:emptyView];
//       
//        [tempemptyView release];
    }
    else {
        
    }
}

#pragma mark - 私有方法 
- (void)addTask:(id)sender
{   
    TaskDetailEditViewController *editController = [[TaskDetailEditViewController alloc] init];
    editController.currentTasklistId = currentTasklistId;
    editController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editController];
    if(MODEL_VERSION >= 5.0)
    {
        [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE] forBarMetrics:UIBarMetricsDefault];
    }
    else {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE]];
        [imageView setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], 44)];
        [navigationController.navigationBar addSubview:imageView];
        [imageView release];
    }
    
    [self.navigationController presentModalViewController:navigationController animated:YES];
}

//创建排序分段控件
- (void)createOrderSegmentedControl
{
    NSArray *buttonNames = [NSArray arrayWithObjects:@"优先级", @"时间", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:buttonNames];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    //segmentedControl.momentary = YES;
    self.navigationItem.titleView = segmentedControl;
    segmentedControl.selectedSegmentIndex = 0;
}

- (void)HUDCompleted{
    [HUD hide:YES];
}


- (void)HUDFailed{
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.labelText = @"请求失败";
    HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:0.3];
}

- (void)addHUD:(NSString *)text{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([text length]) {
        HUD.labelText = text;
    }
}
@end
