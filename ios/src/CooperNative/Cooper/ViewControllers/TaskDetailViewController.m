//
//  TaskDetailViewController.m
//  Cooper
//
//  Created by Ping Li on 12-7-24.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/TaskIdxDao.h"
#import "CooperRepository/ChangeLogDao.h"

@implementation TaskDetailViewController

@synthesize task;
@synthesize dueDateLabel;
@synthesize priorityButton;
@synthesize statusButton;
@synthesize subjectLabel;
@synthesize bodyLabel;
@synthesize commentTextField;
@synthesize delegate;
@synthesize currentTasklistId;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        //[self initContentView];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [detailView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"任务查看";
    }
    return self;
}

- (void)initContentView
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtn] autorelease];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setFrame:CGRectMake(0, 10, 27, 27)];
    [editBtn setBackgroundImage:[UIImage imageNamed:EDIT_IMAGE] forState:UIControlStateNormal];
    [editBtn addTarget: self action: @selector(editTask:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *editButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editBtn] autorelease];
    self.navigationItem.rightBarButtonItem = editButtonItem;
    
    if(task.editable == [NSNumber numberWithInt:0])
    {
        editBtn.hidden = YES;
    }
    else {
        editBtn.hidden = NO;
    }
    
    CGRect tableViewRect = CGRectMake(0, 0, [Tools screenMaxWidth], 1200);
    UITableView* tempTableView = [[[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain] autorelease];
    //[tempTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    //tempTableView.scrollEnabled = NO;
    tempTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tempTableView setBackgroundColor:[UIColor whiteColor]];
    
    //去掉底部空白
    UIView *footer =
    [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    tempTableView.tableFooterView = footer;
    
    detailView = tempTableView;
    detailView.delegate = self;
    detailView.dataSource = self;
    [detailView setAllowsSelection:NO];
    
    [self.view addSubview: detailView];
}

- (void)textView:(JSCoreTextView *)textView linkTapped:(AHMarkedHyperlink *)link
{
	WebViewController *webViewController = [[[WebViewController alloc] init] autorelease];
	[webViewController setUrl:[link URL]];
	BaseNavigationController *navController = [[[BaseNavigationController alloc] initWithRootViewController:webViewController] autorelease];
	[navController setModalPresentationStyle:UIModalPresentationFullScreen];
	[navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];

	[self presentModalViewController:navController animated:YES];
    
//    [[UIApplication sharedApplication] openURL:[link URL]];
}

- (void)goBack:(id)sender
{
    [commentTextField resignFirstResponder];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) sendComment:(NSString *)value
{
    [Tools alert:value];
}

- (void) editTask:(id)sender
{
    TaskDetailEditViewController *editController = [[[TaskDetailEditViewController alloc] init] autorelease];
    editController.delegate = self;
    editController.task = task;
    editController.currentTasklistId = currentTasklistId;
    UINavigationController *navigationController = [[[UINavigationController alloc] autorelease] initWithRootViewController:editController];
    if(MODEL_VERSION >= 5.0)
    {
        [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE] forBarMetrics:UIBarMetricsDefault];
    }
    else {
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE]] autorelease];
        [imageView setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], 44)];
        [navigationController.navigationBar addSubview:imageView];
        //[imageView release];
    }
    
    [self.navigationController presentModalViewController:navigationController animated:YES];
}

- (void)loadTaskData
{
    [delegate loadTaskData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    taskDao = [[TaskDao alloc] init];
    taskIdxDao = [[TaskIdxDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
    
    [self initContentView];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    RELEASE(taskDao);
    RELEASE(taskIdxDao);
    RELEASE(changeLogDao);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//获取TableView的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//获取在制定的分区编号下的纪录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
//填充单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"StatusCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"StatusCell"] autorelease];
                cell.textLabel.text = @"状态:";
                [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                
                statusButton = [[CustomButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"btn_bg_gray.png"]];
                statusButton.userInteractionEnabled = YES;
                
                [statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [statusButton addTarget:self action:@selector(switchStatus) forControlEvents:UIControlEventTouchUpInside];
                
                [statusButton setTitle:@"未完成    >" forState:UIControlStateNormal];
            }
            
            if(self.task != nil)
            {
                [statusButton setTitle: self.task.status == [NSNumber numberWithInt:1] ? @"完成    >" : @"未完成    >" forState:UIControlStateNormal];
                [statusButton setBackgroundImage:[UIImage imageNamed:self.task.status == [NSNumber numberWithInt:1] ? @"btn_bg_green.png" : @"btn_bg_gray.png"] forState:UIControlStateNormal];
                [statusButton setTitleColor: self.task.status == [NSNumber numberWithInt:1] ?[UIColor whiteColor] : [UIColor blackColor] forState:UIControlStateNormal];
            }
            
            CGSize size = CGSizeMake([Tools screenMaxWidth],10000);
            CGSize labelsize = [statusButton.titleLabel.text sizeWithFont:statusButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            [statusButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
            [cell.contentView addSubview:statusButton];
        }
        else if(indexPath.row == 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"DueDateCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DueDateCell"] autorelease];
                cell.textLabel.text = @"截至日期:";
                [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                
                dueDateLabel = [[DateLabel alloc] initWithFrame:CGRectZero];
                dueDateLabel.userInteractionEnabled = YES;
                
                if(task.editable != [NSNumber numberWithInt:0])
                {
                    UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDueDate)];
                    [self.dueDateLabel addGestureRecognizer:recog];
                    self.dueDateLabel.delegate = self;
                    [recog release];
                }
            }
            if(self.task != nil)
            {
                if (task.dueDate == nil) {
                    [self.dueDateLabel setTitle:@"请选择    >" forState:UIControlStateNormal];
                }
                else
                    [self.dueDateLabel setTitle:[NSString stringWithFormat:@"%@    >", [Tools ShortNSDateToNSString:task.dueDate]] forState:UIControlStateNormal];
            }
            
            CGSize size = CGSizeMake([Tools screenMaxWidth],10000);
            CGSize labelsize = [dueDateLabel.titleLabel.text sizeWithFont:dueDateLabel.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            [dueDateLabel setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
            [cell.contentView addSubview:dueDateLabel];
        }
        else if(indexPath.row == 2)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PriorityCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PriorityCell"] autorelease];
                cell.textLabel.text = @"优先级:";
                [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                
                priorityButton = [[PriorityButton alloc] initWithFrame:CGRectZero];
                priorityButton.userInteractionEnabled = YES;
                
                if(task.editable != [NSNumber numberWithInt:0])
                {
                    UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPriority)];
                    [priorityButton addGestureRecognizer:recog];
                    priorityButton.delegate = self;
                    [recog release];
                }
                
                [priorityButton setTitle:[NSString stringWithFormat:@"%@    >",PRIORITY_TITLE_1] forState:UIControlStateNormal];
            }
            
            if(self.task != nil)
            {
                [priorityButton setTitle: [NSString stringWithFormat:@"%@    >", [self getPriorityValue:task.priority]] forState:UIControlStateNormal];
            }
            
            CGSize size = CGSizeMake([Tools screenMaxWidth],10000);
            CGSize labelsize = [priorityButton.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            [priorityButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
            [cell.contentView addSubview:priorityButton];
        }
        else if(indexPath.row == 3)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectBodyCell"];
            
            NSString *font = @"Helvetica";
            CGFloat size = 18.0;
            CGFloat paddingTop = 10.0;
            CGFloat paddingLeft = 10.0;
            
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SubjectBodyCell"] autorelease];
      
                self.subjectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                subjectLabel.userInteractionEnabled = YES;
                [subjectLabel setLineBreakMode:UILineBreakModeWordWrap];
                [subjectLabel setFont:[UIFont boldSystemFontOfSize:16]];
                [cell addSubview:subjectLabel];
                
                bodyLabel = [[[JSCoreTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)] autorelease];
                [bodyLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
                [bodyLabel setDelegate:self];
                [bodyLabel setFontName:font];
                [bodyLabel setFontSize:size];
                [bodyLabel setHighlightColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
                [bodyLabel setBackgroundColor:[UIColor whiteColor]];
                [bodyLabel setPaddingTop:paddingTop];
                [bodyLabel setPaddingLeft:paddingLeft];
                [bodyLabel setLinkColor:APP_BACKGROUNDCOLOR];
                
                [cell addSubview:bodyLabel];
            }
            
            if(task.subject != nil)
            {
                subjectLabel.text = task.subject;
            }
            if(task.body != nil)
            {
                bodyLabel.text = task.body;
            }
            
            CGSize subjectLabelSize = [subjectLabel.text sizeWithFont:subjectLabel.font
                                                    constrainedToSize:CGSizeMake(280 + [Tools screenMaxWidth] - 320, 10000)
                                                        lineBreakMode:UILineBreakModeWordWrap];

            CGFloat subjectLabelHeight = subjectLabelSize.height + 20;

            int subjectlines = subjectLabelHeight / 16;
            int totalLabelHeight = subjectLabelHeight;
            [subjectLabel setFrame:CGRectMake(20, 5, 280 + [Tools screenMaxWidth] - 320, totalLabelHeight)];
            [subjectLabel setNumberOfLines:subjectlines];

            CGFloat bodyLabelHeight = [JSCoreTextView measureFrameHeightForText:bodyLabel.text
                                                              fontName:font
                                                              fontSize:size
                                                    constrainedToWidth:bodyLabel.frame.size.width - (paddingLeft * 2)
                                                            paddingTop:paddingTop
                                                           paddingLeft:paddingLeft];
            CGRect textFrame = [bodyLabel frame];
            textFrame.size.height = bodyLabelHeight;
            textFrame.origin.y = totalLabelHeight;
            [bodyLabel setFrame:textFrame];

            totalLabelHeight += bodyLabelHeight + 800;
            
            [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth],totalLabelHeight)];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"UnknownCell"];
            
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UnknownCell"] autorelease];
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 3)
    {
        UITableViewCell *cell = (UITableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    return 44.0f;
}

- (void)tableViewCell:(DateLabel *)label didEndEditingWithDate:(NSDate *)value
{
    [self.dueDateLabel setTitle:[NSString stringWithFormat:@"%@    >", [Tools ShortNSDateToNSString:value]] forState:UIControlStateNormal];
    
    task.dueDate = value;
    
    [changeLogDao insertChangeLog:[NSNumber numberWithInt:0]
                           dataid:self.task.id
                             name:@"duetime"
                            value:[Tools ShortNSDateToNSString:value]
                       tasklistId:currentTasklistId];
    
    [taskDao commitData];
    
    CGSize size = CGSizeMake(320,10000);
    CGSize labelsize = [dueDateLabel.titleLabel.text sizeWithFont:dueDateLabel.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [dueDateLabel setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
    
    [delegate loadTaskData];
}

- (void)tableViewCell:(PriorityButton *)button didEndEditingWithValue:(NSString *)value
{
    [self.priorityButton setTitle:[NSString stringWithFormat:@"%@    >", value] forState:UIControlStateNormal];
    
    task.priority = [self getPriorityKey:value];
    [changeLogDao insertChangeLog:[NSNumber numberWithInt:0]
                           dataid:self.task.id
                             name:@"priority"
                            value:task.priority
                       tasklistId:currentTasklistId];
    [taskIdxDao updateTaskIdx:self.task.id
                        byKey:self.task.priority
                   tasklistId:currentTasklistId
                     isCommit:NO];
    
    [taskDao commitData];
    
    CGSize size = CGSizeMake(320,10000);
    CGSize labelsize = [priorityButton.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [priorityButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
    
    [delegate loadTaskData];
}

- (void)selectDueDate
{
    [self.dueDateLabel becomeFirstResponder];
}

- (void)selectPriority
{
    [self.priorityButton becomeFirstResponder];
}

- (void)switchStatus
{
    if(task.editable == [NSNumber numberWithInt:0])
        return;
    
    bool isfinish;
    if([statusButton.titleLabel.text isEqualToString:@"未完成    >"])
    {
        [statusButton setTitle:@"完成    >" forState:UIControlStateNormal];
        [statusButton setBackgroundImage:[UIImage imageNamed:@"btn_bg_green.png"] forState:UIControlStateNormal];
        [statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        isfinish = YES;
        
    }
    else
    {
        [statusButton setTitle:@"未完成    >" forState:UIControlStateNormal];
        [statusButton setBackgroundImage:[UIImage imageNamed:@"btn_bg_gray.png"] forState:UIControlStateNormal];
        [statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        isfinish = NO;
    }
    
    self.task.status = [NSNumber numberWithInt: isfinish ? 1 : 0];
    
    [changeLogDao insertChangeLog:[NSNumber numberWithInt:0]
                           dataid:self.task.id name:@"iscompleted"
                            value:isfinish ? @"true" : @"false"
                       tasklistId:currentTasklistId];
    
    [taskDao commitData];
    
    CGSize size = CGSizeMake(320,10000);
    CGSize labelsize = [statusButton.titleLabel.text sizeWithFont:statusButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [statusButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
    
    [delegate loadTaskData];
}

//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if(footerView == nil) {
//        //allocate the view if it doesn't exist yet
//        footerView  = [[UIView alloc] init];
//        [footerView setFrame:CGRectMake(0, 1000, 320, 300)];
//
//
//        self.subjectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        subjectLabel.userInteractionEnabled = YES;
//        [subjectLabel setLineBreakMode:UILineBreakModeWordWrap];
//        [subjectLabel setFont:[UIFont boldSystemFontOfSize:16]];
//        [footerView addSubview:subjectLabel];
//
//        self.bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        bodyLabel.userInteractionEnabled = YES;
//        [bodyLabel setTextColor:[UIColor grayColor]];
//        [bodyLabel setFont:[UIFont systemFontOfSize:14]];
//        [subjectLabel setLineBreakMode:UILineBreakModeWordWrap];
//        [footerView addSubview:bodyLabel];
//
//        if(task.subject != nil)
//        {
//            subjectLabel.text = task.subject;
//        }
//        if(task.body != nil)
//        {
//            bodyLabel.text = task.body;
//        }
//
//        CGSize subjectLabelSize = [subjectLabel.text sizeWithFont:subjectLabel.font
//                                                constrainedToSize:CGSizeMake(280, 10000)
//                                                    lineBreakMode:UILineBreakModeWordWrap];
//
//        CGFloat subjectLabelHeight = subjectLabelSize.height;
//
//        int subjectlines = subjectLabelHeight / 16;
//        int totalLabelHeight = subjectLabelHeight + 20;
//        [subjectLabel setFrame:CGRectMake(20, 5, 280, totalLabelHeight)];
//        [subjectLabel setNumberOfLines:subjectlines];
//
//
//        CGSize bodyLabelSize = [bodyLabel.text sizeWithFont:bodyLabel.font
//                                          constrainedToSize:CGSizeMake(320, 10000)
//                                              lineBreakMode:UILineBreakModeWordWrap];
//
//        CGFloat bodyLabelHeight = bodyLabelSize.height;
//
//        int bodylines = bodyLabelHeight / 16;
//        [bodyLabel setFrame:CGRectMake(20, totalLabelHeight + 10, 280, bodyLabelHeight)];
//        [bodyLabel setNumberOfLines:bodylines];
//
//        totalLabelHeight += bodyLabelHeight;
//
//
//        [detailView setFrame:CGRectMake(0, 0, 320, 2000)];
//        
//    }
//    return footerView; 
//}

- (NSString*)getPriorityKey:(NSString*)priorityValue
{
    if([priorityValue isEqualToString:PRIORITY_TITLE_1])
        return @"0";
    else if([priorityValue isEqualToString:PRIORITY_TITLE_2])
        return @"1";
    else if([priorityValue isEqualToString:PRIORITY_TITLE_3])
        return @"2";
    return @"0";
}
- (NSString*)getPriorityValue:(NSString*)priorityKey
{
    if([priorityKey isEqualToString:@"0"])
        return PRIORITY_TITLE_1;
    else if([priorityKey isEqualToString:@"1"])
        return PRIORITY_TITLE_2;
    else if([priorityKey isEqualToString:@"2"])
        return PRIORITY_TITLE_3;
    return PRIORITY_TITLE_1;
}

@end
