//
//  TeamTaskDetailViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-9-20.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TeamTaskDetailViewController.h"

@implementation TeamTaskDetailViewController

@synthesize task;
@synthesize dueDateLabel;
@synthesize priorityButton;
@synthesize statusButton;
@synthesize subjectLabel;
@synthesize bodyLabel;
@synthesize commentTextField;
@synthesize delegate;
@synthesize currentTeamId;
@synthesize currentProjectId;
@synthesize currentMemberId;
@synthesize currentTag;
@synthesize teamTaskOptionViewController;
@synthesize teamTaskDetailEdit_NavController;
@synthesize teamTaskDetailEditViewController;
@synthesize taskCommentArray;

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
    
    taskDao = [[TaskDao alloc] init];
    taskIdxDao = [[TaskIdxDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
    teamMemberDao = [[TeamMemberDao alloc] init];
    projectDao = [[ProjectDao alloc] init];
    tagDao = [[TagDao alloc] init];
    commentDao = [[CommentDao alloc] init];
    
    [self initContentView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
    
    [taskDao release];
    [taskIdxDao release];
    [changeLogDao release];
    [teamMemberDao release];
    [projectDao release];
    [tagDao release];
    [commentDao release];
    
    [detailView release];
    [assigneeView release];
    [projectView release];
    [tagView release];
    [footerView release];
    
    [dueDateLabel release];
    [priorityButton release];
    [statusButton release];
    [subjectLabel release];
    [bodyLabel release];
    [commentTextField release];
    
    [teamTaskOptionViewController release];
    [teamTaskDetailEdit_NavController release];
    [teamTaskDetailEditViewController release];
    
    [editBtn release];
}

- (void)viewWillAppear:(BOOL)animated
{
    if(![[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
    {
        editBtn.hidden = NO;
    }
    else
    {
        editBtn.hidden = YES;
    }
    
    taskCommentArray = [commentDao getListByTaskId:task.id];
    
    [detailView reloadData];
    
    viewCenter = self.view.center;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 自定义动作

- (void)initContentView
{
    self.title = @"任务查看";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:BACK_IMAGE] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtn] autorelease];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setFrame:CGRectMake(0, 10, 27, 27)];
    [editBtn setBackgroundImage:[UIImage imageNamed:EDIT_IMAGE] forState:UIControlStateNormal];
    [editBtn addTarget: self action: @selector(editTask:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *editButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editBtn] autorelease];
    self.navigationItem.rightBarButtonItem = editButtonItem;
    
    CGRect tableViewRect = CGRectMake(0, 0, [Tools screenMaxWidth], [Tools screenMaxHeight] - 44 - 20);
    UITableView* tempTableView = [[[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain] autorelease];
    tempTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tempTableView setBackgroundColor:[UIColor whiteColor]];
    
    //去掉底部空白
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    tempTableView.tableFooterView = footer;
    
    detailView = tempTableView;
    detailView.delegate = self;
    detailView.dataSource = self;
    [detailView setAllowsSelection:NO];
    
    [self.view addSubview: detailView];
    
    UIView *tabbar = [[UIView alloc] initWithFrame:CGRectMake(0, [Tools screenMaxHeight] - 104, [Tools screenMaxWidth], 40)];
    tabbar.backgroundColor = APP_BACKGROUNDCOLOR;
    commentTextField = [[CommentTextField alloc] init];
    commentTextField.frame = CGRectMake(5, 5, [Tools screenMaxWidth] - 10, 30);
    commentTextField.backgroundColor = [UIColor whiteColor];
    commentTextField.placeholder = @"发表评论";
    commentTextField.font = [UIFont systemFontOfSize:14];
    commentTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    commentTextField.delegate = self;
    [tabbar addSubview:commentTextField];
    [self.view addSubview:tabbar];
    [tabbar release];
}

- (void)textView:(JSCoreTextView *)textView linkTapped:(AHMarkedHyperlink *)link
{
	WebViewController *webViewController = [[[WebViewController alloc] init] autorelease];
	[webViewController setUrl:[link URL]];
	BaseNavigationController *navController = [[[BaseNavigationController alloc] initWithRootViewController:webViewController] autorelease];
	[navController setModalPresentationStyle:UIModalPresentationFullScreen];
	[navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
	[self presentModalViewController:navController animated:YES];
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
    [commentDao addComment:task.id createTime:[NSDate date] body:value];
    [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:2] dataId:task.id name:@"comments" value:value teamId:currentTeamId projectId:currentProjectId memberId:currentMemberId tag:currentTag];
    [changeLogDao commitData];
    
    taskCommentArray = [commentDao getListByTaskId:task.id];
    [detailView reloadData];
}

- (void) editTask:(id)sender
{
    if(teamTaskDetailEdit_NavController == nil)
    {
        teamTaskDetailEditViewController = [[TeamTaskDetailEditViewController alloc] init];   
        teamTaskDetailEdit_NavController = [[BaseNavigationController alloc] initWithRootViewController:teamTaskDetailEditViewController];
    }
    
    teamTaskDetailEditViewController.task = task;
    teamTaskDetailEditViewController.currentTeamId = currentTeamId;
    teamTaskDetailEditViewController.currentProjectId = currentProjectId;
    teamTaskDetailEditViewController.currentMemberId = currentMemberId;
    teamTaskDetailEditViewController.currentTag = currentTag;
    teamTaskDetailEditViewController.delegate = self;
    
//    if(MODEL_VERSION >= 5.0)
//    {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE] forBarMetrics:UIBarMetricsDefault];
//    }
//    else {
//        UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE]] autorelease];
//        [imageView setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], 44)];
//        [self.navigationController.navigationBar addSubview:imageView];
//        //[imageView release];
//    }
    
    [self.navigationController presentModalViewController:teamTaskDetailEdit_NavController animated:YES];
}

- (void)loadTaskData
{
    [delegate loadTaskData];
}

#pragma mark - TableView 事件源

//获取TableView的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//获取在制定的分区编号下的纪录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8 + taskCommentArray.count;
}
//填充单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(tableView == detailView)
    {
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
                    
                    if(![[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
                    {
                        statusButton.userInteractionEnabled = YES;
                    }
                    else
                    {
                        statusButton.userInteractionEnabled = NO;
                    }
                    
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
                    [cell.textLabel setTextColor:[UIColor grayColor]];
                    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    
                    dueDateLabel = [[DateLabel alloc] initWithFrame:CGRectZero];
                    if(![[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
                    {
                        UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDueDate)];
                        [self.dueDateLabel addGestureRecognizer:recog];
                        self.dueDateLabel.delegate = self;
                        [recog release];
                        dueDateLabel.userInteractionEnabled = YES;
                    }
                    else
                    {
                        dueDateLabel.userInteractionEnabled = NO;
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

                    if(![[task.editable stringValue] isEqualToString: [[NSNumber numberWithInt:0] stringValue]])
                    {
                        UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPriority)];
                        [priorityButton addGestureRecognizer:recog];
                        priorityButton.delegate = self;
                        [recog release];
                        priorityButton.userInteractionEnabled = YES;
                    }
                    else
                    {
                        priorityButton.userInteractionEnabled = NO;
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
                cell = [tableView dequeueReusableCellWithIdentifier:@"AssigneeCell"];
                if(!cell)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AssigneeCell"] autorelease];
                    cell.textLabel.text = @"执行人:";
                    [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    
                    assigneeView = [[UIView alloc] initWithFrame:CGRectZero];
                    if(![[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
                    {
                        assigneeView.userInteractionEnabled = YES;
                    }
                    else
                    {
                        assigneeView.userInteractionEnabled = NO;
                    }
                    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAssignee:)];
                    [assigneeView addGestureRecognizer:recognizer];
                    [recognizer release];
                    [cell.contentView addSubview:assigneeView];
                }
                
                TeamMember *teamMember = [teamMemberDao getTeamMemberByTeamId:currentTeamId assigneeId:task.assigneeId];
                if(teamMember != nil)
                {
                    CustomButton *memberBtn = [[CustomButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"btn_bg_gray.png"]];
                    memberBtn.userInteractionEnabled = NO;
                    [memberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [memberBtn setTitle:teamMember.name forState:UIControlStateNormal];
                    CGSize size = CGSizeMake([Tools screenMaxWidth],10000);
                    CGSize labelsize = [memberBtn.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
                    CGFloat labelsizeHeight = labelsize.height + 10;
                    memberBtn.frame = CGRectMake(0, 8, labelsize.width + 40, labelsizeHeight);         
                    [assigneeView addSubview:memberBtn];  
                    [memberBtn release];
                             
                    assigneeView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, labelsizeHeight);
                    
                    [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], labelsizeHeight + 15)];
                }
                else
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 120, 30)];
                    label.textColor = [UIColor grayColor];
                    label.text = @"none";
                    [assigneeView addSubview:label];
                    [label release];
                    
                    assigneeView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, 44);  
                }
            }
            else if(indexPath.row == 4)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectCell"];
                if(!cell)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ProjectCell"] autorelease];
                    cell.textLabel.text = @"项目:";
                    [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    
                    projectView = [[UIView alloc] initWithFrame:CGRectZero];
                    if(![[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
                    {
                        projectView.userInteractionEnabled = YES;
                    }
                    else
                    {
                        projectView.userInteractionEnabled = NO;
                    }
                    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectProject:)];
                    [projectView addGestureRecognizer:recognizer];
                    [recognizer release];
                    [cell.contentView addSubview:projectView];
                }
                
                if(task.projects != nil)
                {
                    NSMutableArray *projectArray = [task.projects JSONValue];
                    if(projectArray.count == 0)
                    {
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 120, 30)];
                        label.textColor = [UIColor grayColor];
                        label.text = @"none";
                        [projectView addSubview:label];
                        [label release];
                        
                        projectView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, 44);
                    }
                    else
                    {
                        CGFloat totalHeight = 0;
                        for (NSMutableDictionary *projectDict in projectArray)
                        {
                            NSString *projectName = [projectDict objectForKey:@"name"];
                            CustomButton *projectBtn = [[CustomButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"btn_bg_gray.png"]];
                            projectBtn.userInteractionEnabled = NO;
                            [projectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            [projectBtn setTitle:projectName forState:UIControlStateNormal];
                            CGSize size = CGSizeMake([Tools screenMaxWidth], 10000);
                            CGSize labelsize = [projectBtn.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
                            CGFloat labelsizeHeight = labelsize.height + 10;
                            projectBtn.frame = CGRectMake(0, 8 + totalHeight, labelsize.width + 40, labelsizeHeight);
                            [projectView addSubview:projectBtn];
                            [projectBtn release];
                            
                            totalHeight += labelsizeHeight + (projectArray.count > 1 ? 5 : 0);
                        }
                        projectView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, totalHeight);
                        [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], totalHeight + 15)];
                    }
                }
                else
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 120, 30)];
                    label.textColor = [UIColor grayColor];
                    label.text = @"none";
                    [projectView addSubview:label];
                    [label release];
                    
                    projectView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, 44);
                }
            }
            else if(indexPath.row == 5)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell"];
                if(!cell)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TagCell"] autorelease];
                    cell.textLabel.text = @"标签:";
                    [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    
                    tagView = [[UIView alloc] initWithFrame:CGRectZero];
                    if(![[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
                    {
                        tagView.userInteractionEnabled = YES;
                    }
                    else
                    {
                        tagView.userInteractionEnabled = NO;
                    }
                    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTag:)];
                    [tagView addGestureRecognizer:recognizer];
                    [recognizer release];
                    [cell.contentView addSubview:tagView];
                }
                
                if(task.tags != nil)
                {
                    NSMutableArray *tagArray = [task.tags JSONValue];
                    if(tagArray.count == 0)
                    {
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 120, 30)];
                        label.textColor = [UIColor grayColor];
                        label.text = @"none";
                        [tagView addSubview:label];
                        [label release];
                        
                        tagView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, 44);
                    }
                    else
                    {
                        CGFloat totalHeight = 0;
                        for (NSString *tagName in tagArray)
                        {
                            CustomButton *tagBtn = [[CustomButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"btn_bg_gray.png"]];
                            tagBtn.userInteractionEnabled = NO;
                            [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            [tagBtn setTitle:tagName forState:UIControlStateNormal];
                            CGSize size = CGSizeMake([Tools screenMaxWidth], 10000);
                            CGSize labelsize = [tagBtn.titleLabel.text sizeWithFont:tagBtn.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
                            CGFloat labelsizeHeight = labelsize.height + 10;
                            tagBtn.frame = CGRectMake(0, 8 + totalHeight, labelsize.width + 40, labelsizeHeight);
                            [tagView addSubview:tagBtn];
                            [tagBtn release];
                            
                            totalHeight += labelsizeHeight + (tagArray.count > 1 ? 5 : 0);
                        }
                        tagView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, totalHeight);
                        [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], totalHeight + 15)];
                    }
                }
                else
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 120, 30)];
                    label.textColor = [UIColor grayColor];
                    label.text = @"none";
                    [tagView addSubview:label];
                    [label release];
                    
                    tagView.frame = CGRectMake(110, 0, [Tools screenMaxWidth] - 110, 44);
                }
            }
            else if(indexPath.row == 6)
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
                
                totalLabelHeight += bodyLabelHeight + 10;
                [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], totalLabelHeight)];
            }
            else if(indexPath.row == 7)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCreatorCell"];
                if(!cell)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TaskCreatorCell"] autorelease];
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
                    
                    TeamMember *taskCreator = [teamMemberDao getTeamMemberByTeamId:currentTeamId assigneeId:task.createMemberId];
                    if(taskCreator != nil)
                    {
                        cell.textLabel.text = [NSString stringWithFormat:@"%@ 创建了任务", taskCreator.name];
                        cell.detailTextLabel.text = [NSString stringWithFormat:@" - %@", [Tools NSDateToNSString:task.createDate]];
                    }
                }
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCommentCell"];
                
                if(!cell)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TaskCommentCell"] autorelease];
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
                    
                    Comment *comment = [taskCommentArray objectAtIndex:indexPath.row - 8];
                    if(comment != nil)
                    {
                        if(comment.creatorId != nil)
                        {
                            TeamMember *commentor = [teamMemberDao getTeamMemberByTeamId:currentTeamId assigneeId:comment.creatorId];
                            if(commentor != nil)
                            {
                                cell.textLabel.text = [NSString stringWithFormat:@"%@ 发表了评论", commentor.name];    
                            }
                        }
                        else
                        {
                            NSString *commentorName = [[ConstantClass instance] username];
                            cell.textLabel.text = [NSString stringWithFormat:@"%@ 发表了评论", commentorName];
                        }
                        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
                        NSString *word = [NSString stringWithFormat:@"%@\n - %@"
                                          , comment.body
                                          , [Tools NSDateToNSString:comment.createTime]];
                        cell.detailTextLabel.text = word;
                        CGSize detailTextLabelSize = [cell.detailTextLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([Tools screenMaxWidth], 10000) lineBreakMode:UILineBreakModeWordWrap];
                        CGFloat detailTextLabelHeight = detailTextLabelSize.height;
                        int subjectlines = detailTextLabelHeight / 14;
                        cell.detailTextLabel.numberOfLines = subjectlines;
                        [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], detailTextLabelHeight + 40)];
                    }
                }
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableViewCell:(DateLabel *)label didEndEditingWithDate:(NSDate *)value
{
    [self.dueDateLabel setTitle:[NSString stringWithFormat:@"%@    >", [Tools ShortNSDateToNSString:value]] forState:UIControlStateNormal];
    
    task.dueDate = value;
    
    [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                 dataId:self.task.id
                                   name:@"duetime"
                                  value:[Tools ShortNSDateToNSString:value]
                                 teamId:currentTeamId
                              projectId:currentProjectId
                               memberId:currentMemberId
                                    tag:currentTag];
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
    [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                 dataId:self.task.id
                                   name:@"priority"
                                  value:task.priority
                                 teamId:currentTeamId
                              projectId:currentProjectId
                               memberId:currentMemberId
                                    tag:currentTag];
    [taskIdxDao updateTaskIdxByTeam:self.task.id
                              byKey:self.task.priority
                             teamId:currentTeamId
                          projectId:currentProjectId
                           memberId:currentMemberId
                                tag:currentTag];
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
    if([[task.editable stringValue] isEqualToString:[[NSNumber numberWithInt:0] stringValue]])
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
    
    [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                 dataId:self.task.id name:@"iscompleted"
                                  value:isfinish ? @"true" : @"false"
                                 teamId:currentTeamId
                              projectId:currentProjectId
                               memberId:currentMemberId
                                    tag:currentTag];
    [taskDao commitData];
    
    CGSize size = CGSizeMake(320,10000);
    CGSize labelsize = [statusButton.titleLabel.text sizeWithFont:statusButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [statusButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
    
    [delegate loadTaskData];
}

- (void)selectAssignee:(id)sender
{
    if (teamTaskOptionViewController == nil)
    {
        teamTaskOptionViewController = [[TeamTaskOptionViewController alloc] init];
    }
    
    teamTaskOptionViewController.currentTask = task;
    teamTaskOptionViewController.selectMultiple = NO;
    teamTaskOptionViewController.optionType = 1;
    teamTaskOptionViewController.currentTeamId = currentTeamId;
    teamTaskOptionViewController.currentProjectId = currentProjectId;
    teamTaskOptionViewController.currentMemberId = currentMemberId;
    teamTaskOptionViewController.currentTag = currentTag;

    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:teamTaskOptionViewController animated:NO];
}

- (void)selectProject:(id)sender
{
    if (teamTaskOptionViewController == nil)
    {
        teamTaskOptionViewController = [[TeamTaskOptionViewController alloc] init];
    }
    
    teamTaskOptionViewController.currentTask = task;
    teamTaskOptionViewController.selectMultiple = YES;
    teamTaskOptionViewController.optionType = 2;
    teamTaskOptionViewController.currentTeamId = currentTeamId;
    teamTaskOptionViewController.currentProjectId = currentProjectId;
    teamTaskOptionViewController.currentMemberId = currentMemberId;
    teamTaskOptionViewController.currentTag = currentTag;
    
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:teamTaskOptionViewController animated:NO];
}

- (void)selectTag:(id)sender
{
    if (teamTaskOptionViewController == nil)
    {
        teamTaskOptionViewController = [[TeamTaskOptionViewController alloc] init];
    }
    
    teamTaskOptionViewController.currentTask = task;
    teamTaskOptionViewController.selectMultiple = YES;
    teamTaskOptionViewController.optionType = 3;
    teamTaskOptionViewController.currentTeamId = currentTeamId;
    teamTaskOptionViewController.currentProjectId = currentProjectId;
    teamTaskOptionViewController.currentMemberId = currentMemberId;
    teamTaskOptionViewController.currentTag = currentTag;
    
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:teamTaskOptionViewController animated:NO];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
	CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration =
	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    CGPoint center = viewCenter;
    NSLog(@"key:%f", keyboardRect.size.height);
    center.y -= keyboardRect.size.height;
    detailView.frame = CGRectMake(0, 0, [Tools screenMaxWidth], [Tools screenMaxHeight] - 124);
    center.y += 60.0f;
    self.view.center = center;
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSTimeInterval animationDuration =
	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    self.view.center = viewCenter;
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

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
