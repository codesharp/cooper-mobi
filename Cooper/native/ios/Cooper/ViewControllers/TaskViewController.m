//
//  TaskViewController.m
//  Cooper
//
//  Created by sunleepy on 12-6-29.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskViewController.h"
#import "AppDelegate.h"
#import "SBJsonParser.h"
#import "TaskDao.h"
#import "TaskIdxDao.h"
#import "CustomTabBarController.h"
#import "CustomToolbar.h"

@implementation TaskViewController

@synthesize taskIdxGroup;
@synthesize taskGroup;
@synthesize filterStatus;

#pragma mark - life cycle

//初始化
- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
             setTitle:(NSString *)title 
             setImage:(NSString*)imageName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"cooper:task";
        CustomTabBarItem *tabBarItem = [[CustomTabBarItem alloc] init];
        [tabBarItem setTitle:title];
        [tabBarItem setCustomImage:[UIImage imageNamed:imageName]];
        self.tabBarItem = tabBarItem;    
        [tabBarItem release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.tableView setEditing:YES animated:YES];
    // self.clearsSelectionOnViewWillAppear = NO;
    //[self createOrderSegmentedControl];
    
    CustomToolbar *toolBar = [[CustomToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 45.0f)];
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setFrame:CGRectMake(5, 10, 27, 27)];
    editBtn.contentMode = UIViewContentModeScaleToFill;
    editBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [editBtn setBackgroundImage:[UIImage imageNamed:@"tasklist.png"] forState:UIControlStateNormal];
    [editBtn addTarget: self action: self.editButtonItem.action forControlEvents: UIControlEventTouchUpInside];
    [toolBar addSubview:editBtn];
    
    UIButton *syncBtn = [UIButton buttonWithType:UIButtonTypeCustom]; 
    [syncBtn setFrame:CGRectMake(45, 10, 27, 27)];
    [syncBtn setBackgroundImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    [syncBtn addTarget: self action: @selector(syncAction:) forControlEvents: UIControlEventTouchUpInside];
    [toolBar addSubview:syncBtn];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolBar]; 
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    [barButtonItem release];
    [toolBar release];
    
    //设置右选项卡中的按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0, 10, 25, 25)];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [addBtn addTarget: self action: @selector(addTask:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];

    self.navigationItem.rightBarButtonItem = addButtonItem; 
    
    [addBtn release];
    [addButtonItem release];
    
    taskDao = [[TaskDao alloc] init];
    taskIdxDao = [[TaskIdxDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
       
    if(filterStatus == nil)
    {
#ifndef CODESHARP_VERSION
        if([[[Constant instance] username] length] == 0 || [[[Constant instance] domain] length] == 0)
#else
        if([[[Constant instance] username] length] == 0)       
#endif
        {
            [Tools alert:@"请先设置帐号才可以同步"];
        }
        else
        {
            [self addHUD:@"加载数据中"];
            requestType = 0;
            [TaskService syncTask:self];
            //requestType = 3;
            //[TaskService testUrl:self];
        }
    }
    [self loadTaskData];
}

- (void)syncAction:(id)sender
{
    NSLog(@"syncAction");
    if([[[Constant instance] username] length] == 0 || [[[Constant instance] domain] length] == 0)
    {
        [Tools alert:@"请先设置帐号才可以同步"];
    }
    else {
        [self addHUD:@"加载数据中"];
        requestType = 0;
        [TaskService syncTask:self];
    }
}

- (void)addRequstToPool:(ASIHTTPRequest *)request {
    //    [requestPool addObject:request];
    NSLog(@"发送请求：%@",request.url);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"response data: %@, %d", [request responseString], [request responseStatusCode]);

    if(requestType == 0)
    {
        NSMutableArray *array = [[request responseString] JSONValue];
        
        if(array.count > 0)
        {
            for(NSMutableDictionary *dict in array)
            {
                NSString * oldId = (NSString*)[dict objectForKey:@"OldId"];
                NSString * newId = (NSString*)[dict objectForKey:@"NewId"];
                
                NSLog(@"OldId:%@, NewId:%@", oldId, newId);
                
                [taskDao updateTaskIdByNewId:oldId newId:newId];
                [taskIdxDao updateTaskIdxByNewId:oldId newId:newId];
            }
        }
        
        //修正changeLog
        [changeLogDao updateAllToSend];
        [changeLogDao commitData];
        
        requestType = 1;
        [TaskService getTasks:self];
    }
    else if(requestType == 1) {
        [self HUDCompleted];
        
        NSLog(@"getByPriority ResponseString:%@", [request responseString]);
        NSDictionary *dict = nil;
        @try
        {
            dict = [[request responseString] JSONValue];
            
            if(dict)
            {
            NSArray *tasks = [dict objectForKey:@"List"]; 
            NSArray *taskIdxs =[dict objectForKey:@"Sorts"];
            
            [taskDao deleteAll];
            [taskIdxDao deleteAllTaskIdx];
            
            [taskIdxDao commitData];
            
            for(NSDictionary *taskDict in tasks)
            {
                NSString *taskId = [NSString stringWithFormat:@"%@", (NSString*)[taskDict objectForKey:@"ID"]];  
                
                NSString *s = [taskDict objectForKey:@"Subject"];
                NSString* subject = s == [NSNull null] ? @"" : s;
                
                
                NSString *b = [taskDict objectForKey:@"Body"];
                NSString *body = b == [NSNull null] ? @"" : b;
                NSString *isCompleted = (NSString*)[taskDict objectForKey:@"IsCompleted"];
                NSString *status = [NSNumber numberWithInteger:[isCompleted integerValue]];    
                NSString *priority = [NSString stringWithFormat:@"%@", [taskDict objectForKey:@"Priority"]];
                
                NSString *dueTime = (NSString*)[taskDict objectForKey:@"DueTime"];
                NSDate *due = nil;
                if(dueTime != [NSNull null])
                {
                    due = [Tools NSStringToShortNSDate:dueTime];
                }
                
                NSLog(@"%@,%@,%@,%@,%@,%@,%@,", taskId, subject, body, isCompleted, status, priority, dueTime);
                [taskDao addTask:subject createDate:[NSDate date] lastUpdateDate:[NSDate date] body:body isPublic:[NSNumber numberWithInt:1] status:[NSNumber numberWithInt:[isCompleted integerValue]] priority:priority taskid:taskId dueDate:due isCommit:NO];
            }
            
            for(NSDictionary *idxDict in taskIdxs)
            {            
                NSString *by = (NSString*)[idxDict objectForKey:@"By"];
                NSString *key = (NSString*)[idxDict objectForKey:@"Key"];
                NSString *name = (NSString*)[idxDict objectForKey:@"Name"];  
                
                NSArray *array = (NSArray*)[idxDict objectForKey:@"Indexs"];
                NSString *indexes = [array JSONRepresentation];
                
                [taskIdxDao addTaskIdx:by key:key name:name indexes:indexes];
            }
            
            [taskIdxDao commitData];
            
            [self loadTaskData];
            }
        }
        @catch (NSException *exception) 
        {
            NSLog(@"exception message:%@", [exception description]);
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request error %@",request.error);
    [self HUDCompleted];
}

- (void)dealloc
{
    [taskDao release];
    [taskIdxDao release];
    [changeLogDao release];
    [taskGroup release];
    [taskIdxGroup release];

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
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return 1;
    return self.taskIdxGroup.count;
}
//获取在制定的分区编号下的纪录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    //设置选中后cell的背景颜色
    cell.selectedBackgroundView = selectedView;   
    [selectedView release];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressRecognizer.minimumPressDuration = 1;
    [cell addGestureRecognizer:longPressRecognizer];
//    longPressRecognizer.allowableMovement = NO;
//    longPressRecognizer.minimumPressDuration = 0.2;
    [longPressRecognizer release];
    
    return cell;
}

-(IBAction)handleLongPress:(id)sender{  
    TaskTableViewCell *cell = (TaskTableViewCell*)[(UILongPressGestureRecognizer *)sender view];
    NSLog(@"hi cell");
    [cell setEditing:YES animated:YES];
    //NSInteger ttag=[button tag];
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
    Task *task = [[self.taskGroup objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:YES animated:YES];
    
    return indexPath;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *titleLabel = [[[UILabel alloc]init]autorelease];
    titleLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sectionTitlebg.png"]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [titleLabel setTextColor:[UIColor grayColor]];
    
    
    if(section == 0)
        titleLabel.text = @"  今天";
    else if(section == 1)
        titleLabel.text = @"  稍后完成";
    else if(section == 2)
        titleLabel.text = @"  迟些再说";
    
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
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:1] dataid:t.id name:@"" value:@""];      
        [taskIdxDao deleteTaskIndexsByTaskId:t.id];      
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
            [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] dataid:task.id name:@"priority" value:task.priority];
        } 
        NSLog(@"sourceIndexPath:%d, toIndexPath:%d", sourceIndexPath.row, destinationIndexPath.row);
        
        [taskIdxDao adjustIndex:task.id sourceTaskIdx: sTaskIdx destinationTaskIdx: dTaskIdx sourceIndexRow:sourceIndexPath.row destIndexRow:destinationIndexPath.row];
        
        [taskDao commitData];
    }
}
//分区标题输出
- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return @"";
    }
    
    //TODO:...
    if(section == 0)
        return @"今天";
    else if(section == 1)
        return @"稍后完成";
    else if(section == 2)
        return @"迟些再说";
    
    return @"";
}

- (void) didSelectCell:(Task*)task
{
    TaskDetailViewController *detailController = [[[TaskDetailViewController alloc] init] autorelease];
    detailController.task = task;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:detailController];
    if(MODEL_VERSION >= 5.0)
    {
        [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else {
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigationbar_bg.png"]] autorelease];
        [imageView setFrame:CGRectMake(0, 0, 320, 44)];
        [navigationController.navigationBar addSubview:imageView];
    }
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [self.navigationController presentModalViewController:navigationController animated:YES];
}

//点击单元格事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    TaskDetailViewController *detailController = [[[TaskDetailViewController alloc] init] autorelease];
    Task *task = [[self.taskGroup objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    detailController.task = task;
    
    [detailController setHidesBottomBarWhenPushed:YES];
    detailController.delegate = self;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
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
    NSLog(@"loadTaskData");
    
    self.taskIdxGroup = [NSMutableArray array];
    self.taskGroup = [NSMutableArray array];
    
    NSMutableArray *taskIdxs = [taskIdxDao getAllTaskIdx];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    for(TaskIdx *taskIdx in taskIdxs)
    {
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
}

#pragma mark - 私有方法 
- (void)addTask:(id)sender
{   
    TaskDetailEditViewController *editController = [[TaskDetailEditViewController alloc] init];
    editController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editController];
    if(MODEL_VERSION >= 5.0)
    {
        [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE] forBarMetrics:UIBarMetricsDefault];
    }
    else {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE]];
        [imageView setFrame:CGRectMake(0, 0, 320, 44)];
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
