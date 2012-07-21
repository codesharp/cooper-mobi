//
//  TaskViewController.m
//  Cooper
//
//  Created by sunleepy on 12-6-29.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskViewController.h"
#import "AppDelegate.h"
#import "TaskViewCell.h"
#import "SBJsonParser.h"
#import "TaskDao.h"
#import "TaskIdxDao.h"

@implementation TaskViewController

@synthesize taskIdxGroup;
@synthesize taskGroup;
@synthesize filteredtaskGroup;
@synthesize filterStatus;

//@synthesize savedSearchTerm;
//@synthesize savedScopeButtonIndex;
//@synthesize searchWasActive;

#pragma mark - life cycle

//初始化
- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
             setTitle:(NSString *)title 
             setImage:(NSString*)imageName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(title, title);
        self.tabBarItem.image = [UIImage imageNamed:imageName];
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
//    UITableView *tv = self.view;
//
//    for (int i = 0; i < self.taskGroup.count; i++) {
//        for(int j = 0; j < [[self.taskGroup objectAtIndex:i] count]; j++)
//        {
//            TaskViewCell *cell = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
//            cell.completeBtn.hidden = editing;
//        }
//    }
    [super setEditing:editing animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchDisplayController.searchBar.tintColor = APP_BACKGROUNDCOLOR;
    
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //[self createOrderSegmentedControl];
    
    UIButton *syncBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [syncBtn setTitle:@"同步" forState:UIControlStateNormal];
    [syncBtn addTarget:self action:@selector(syncAction:) forControlEvents:UIControlEventTouchUpInside];
    syncBtn.frame = CGRectMake(0,0,70,30);
    self.navigationItem.titleView = syncBtn;
 
    [self.editButtonItem setTitle:@"编辑"];
    //设置左选项卡中的按钮
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //设置右选项卡中的按钮
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(insertNewObject:)] autorelease];
    //UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(insertNewObject:)] autorelease]; 
    //[addButton setTitle:@"添加"];
    self.navigationItem.rightBarButtonItem = addButton; 
    
    taskDao = [[TaskDao alloc] init];
    taskIdxDao = [[TaskIdxDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
       
    if(filterStatus == nil)
    {
        if([[[Constant instance] username] length] == 0 || [[[Constant instance] domain] length] == 0)
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
        
        [taskDao deleteAll];
        [taskIdxDao deleteAllTaskIdx];
        
        [taskIdxDao commitData];
        
        NSDictionary *dict = [[request responseString] JSONValue];
        
        NSArray *tasks = [dict objectForKey:@"List"]; 
        NSArray *taskIdxs =[dict objectForKey:@"Sorts"];
            
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

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request error %@",request.error);
    [self HUDCompleted];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [taskDao release];
    [taskIdxDao release];
    [changeLogDao release];
    
    self.filteredtaskGroup = nil;
    self.taskIdxGroup = nil;
    self.taskGroup = nil;
    NSLog(@"viewdidUnload");
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
//    self.searchWasActive = [self.searchDisplayController isActive];
//    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
//    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}

- (void)dealloc
{
    [filteredtaskGroup release];
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
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return [self.filteredtaskGroup count];
    return [[self.taskGroup objectAtIndex:section] count];
}
//填充单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaskViewCell";
    TaskViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
	{
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskViewCell" owner:self options:nil] lastObject];
	}
    Task *task = nil;
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        task = [self.filteredtaskGroup objectAtIndex:indexPath.row];    
    }
    else 
    {
        task = [[self.taskGroup objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    cell.task = task;
    [cell initCheck];
    
    cell.indentationWidth = 30;
    cell.indentationLevel = 1;
    cell.textLabel.text = task.subject;

    NSArray *subviews = [cell.contentView subviews];  
    for(id view in subviews)  
    {  
        if([view isKindOfClass:[UIButton class]])  
                        
            [cell.contentView bringSubviewToFront:view];    
    }  
    return cell;
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


//点击右侧箭号
- (void) tableView:(UITableView*)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{  
    
}

//点击标准编辑按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if(tableView == self.searchDisplayController.searchResultsTableView)
        {
            Task *t = [self.filteredtaskGroup objectAtIndex:indexPath.row];
            [taskDao deleteTask:t];
            [changeLogDao insertChangeLog:[NSNumber numberWithInt:1] dataid:t.id name:@"" value:@""]; 
            [taskIdxDao deleteTaskIndexsByTaskId:t.id];
            [t release];
            
            [self.filteredtaskGroup removeObjectAtIndex:indexPath.row];
        }
        else 
        {       
            Task *t = [[self.taskGroup objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [changeLogDao insertChangeLog:[NSNumber numberWithInt:1] dataid:t.id name:@"" value:@""];      
            [taskIdxDao deleteTaskIndexsByTaskId:t.id];      
            [taskDao deleteTask:t];
            
            [taskDao commitData];
            [t release];
            
            [[self.taskGroup objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];        
        }
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view

    }   else {

    }
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
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
//点击单元格事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    DetailViewController *detailController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil] autorelease];
    
    Task *task = nil;
    if (self.tableView == tableView)
    {
        task = [[self.taskGroup objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
	else
    {
        task = [self.filteredtaskGroup objectAtIndex:indexPath.row];
    }
    
    [detailController setTask:task];
    detailController.delegate = self;
    
    [[UIApplication sharedApplication] delegate];
    [self.navigationController pushViewController:detailController animated:YES];
}
//过滤搜索事件
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.filteredtaskGroup removeAllObjects];
    
    for(NSMutableArray *array in self.taskGroup)
    {
        for(Task *task in array)
        {
            NSComparisonResult result = [task.subject compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
				[self.filteredtaskGroup addObject:task];
            }
        }
    }
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];

    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    NSLog(@"shouldReloadTableForSearchScope");
    return YES;
}

- (void)loadTaskData
{
    NSLog(@"loadTaskData");
    
    //初始化任务列表
    self.filteredtaskGroup = [NSMutableArray array];   
    
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
    [self.searchDisplayController setActive:NO];
}

#pragma mark - 私有方法 
- (void)insertNewObject:(id)sender
{   
    DetailViewController *detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil] autorelease];
    
    detailViewController.delegate = self;
    [self.navigationController pushViewController:detailViewController animated:YES];
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
