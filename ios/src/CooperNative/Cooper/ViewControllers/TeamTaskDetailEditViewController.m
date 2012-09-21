//
//  TeamTaskDetailEditViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-9-21.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TeamTaskDetailEditViewController.h"
#import "CustomButton.h"

@implementation TeamTaskDetailEditViewController

@synthesize task;
@synthesize dueDateLabel;
@synthesize priorityButton;
@synthesize statusButton;
@synthesize bodyScrollView;
@synthesize subjectTextField;
@synthesize bodyTextView;
@synthesize bodyCell;
@synthesize delegate;
@synthesize currentTeamId;
@synthesize currentProjectId;
@synthesize currentMemberId;
@synthesize currentTag;
@synthesize taskCommentArray;
@synthesize teamTaskOptionViewController;

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
	
    taskDao = [[TaskDao alloc] init];
    taskIdxDao = [[TaskIdxDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
    teamMemberDao = [[TeamMemberDao alloc] init];
    projectDao = [[ProjectDao alloc] init];
    tagDao = [[TagDao alloc] init];
    commentDao = [[CommentDao alloc] init];
    
    currentDueDate = nil;
    currentStatus = 0;
    currentPriority = @"0";
    
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
    
    [dueDateLabel release];
    [priorityButton release];
    [statusButton release];
    
    [bodyTextView release];
    [bodyScrollView release];
    [subjectTextField release];
    
    [teamTaskOptionViewController release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    self.title = @"任务编辑";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:BACK_IMAGE] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtn] autorelease];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    CustomButton *saveTaskBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(5,5,50,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
    saveTaskBtn.layer.cornerRadius = 6.0f;
    [saveTaskBtn.layer setMasksToBounds:YES];
    [saveTaskBtn addTarget:self action:@selector(saveTask:) forControlEvents:UIControlEventTouchUpInside];
    [saveTaskBtn setTitle:@"确定" forState:UIControlStateNormal];
    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithCustomView:saveTaskBtn] autorelease];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    CGRect tableViewRect = CGRectMake(0, 0, [Tools screenMaxWidth], [Tools screenMaxHeight]);
    UITableView* tempTableView = [[[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain] autorelease];
    tempTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tempTableView setBackgroundColor:[UIColor whiteColor]];
    
    //去掉底部空白
    UIView *footer =
    [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    tempTableView.tableFooterView = footer;
    [footer release];
    
    detailView = tempTableView;
    
    [detailView setAllowsSelection:NO];
    
    [self.view addSubview: detailView];
    detailView.delegate = self;
    detailView.dataSource = self;
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
    [delegate loadTaskData];
    
    if(self.task == nil)
        [self.navigationController dismissModalViewControllerAnimated:YES];
    else {
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
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
    return 8;
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
                    {
                        [self.dueDateLabel setTitle:[NSString stringWithFormat:@"%@    >", [Tools ShortNSDateToNSString:task.dueDate]] forState:UIControlStateNormal];
                        currentDueDate = [task.dueDate copy];
                    }
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
                    oldPriority = [task.priority copy];
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
                
                if(task != nil)
                {
                    currentAssigneeId = task.assigneeId;
                }
                
                TeamMember *teamMember = [teamMemberDao getTeamMemberByTeamId:currentTeamId assigneeId:currentAssigneeId];
                if(teamMember != nil)
                {
                    currentAssigneeId = teamMember.id;
                    
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
                
                if(task != nil)
                {
                    currentProjects = task.projects;
                }
                
                if(currentProjects != nil)
                {
                    NSMutableArray *projectArray = [currentProjects JSONValue];
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
                
                if(task != nil)
                {
                    currentTags = task.tags;
                }
                
                if(currentTags != nil)
                {
                    NSMutableArray *tagArray = [currentTags JSONValue];
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
                            CGSize labelsize = [tagBtn.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
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
                cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectCell"];
                if(!cell)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SubjectCell"] autorelease];
                    cell.textLabel.text = @"标题:";
                    [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                    
                    subjectTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, [Tools screenMaxWidth] - 120, 25)];
                    subjectTextField.userInteractionEnabled = YES;
                    [subjectTextField setReturnKeyType:UIReturnKeyDone];
                    [subjectTextField setTextAlignment:UITextAlignmentLeft];
                    [subjectTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                    [subjectTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
                    [subjectTextField setPlaceholder:@"标题"];
                    [subjectTextField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
                    [cell.contentView addSubview:subjectTextField];
                }
                
                if(task != nil)
                {
                    subjectTextField.text = task.subject;
                }
            }
            else if(indexPath.row == 7)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"BodyCell"];
                if(!cell)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BodyCell"] autorelease];
                    
                    bodyTextView = [[BodyTextView alloc] initWithFrame:self.view.frame];
                    bodyTextView.userInteractionEnabled = YES;
                    [bodyTextView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                    [bodyTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
                    bodyTextView.returnKeyType = UIReturnKeyDefault;
                    bodyTextView.keyboardType = UIReturnKeyDone;
                    bodyTextView.scrollEnabled = YES;
                    bodyTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                    bodyTextView.delegate = self;
                    [bodyTextView setFont:[UIFont systemFontOfSize:16]];
                    
                    bodyScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)] autorelease];
                    [bodyScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
                    [bodyScrollView setContentSize:bodyTextView.frame.size];
                    [bodyScrollView addSubview:bodyTextView];
                    
                    [cell addSubview:bodyScrollView];
                    
                    bodyCell = cell;
                }
                
                if(task != nil)
                {
                    bodyTextView.text = task.body;
                }
                
                int totalheight = bodyTextView.contentSize.height;
                //            if(bodyTextView.contentSize.height < 300)
                //            {
                //                totalheight = 300;
                //            }
                [cell setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], totalheight + 200)];
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
    
    currentDueDate = [value copy];
    if(task != nil)
    {
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
    }
    
    CGSize size = CGSizeMake(320,10000);
    CGSize labelsize = [dueDateLabel.titleLabel.text sizeWithFont:dueDateLabel.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [dueDateLabel setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
    
    [delegate loadTaskData];
}

- (void)tableViewCell:(PriorityButton *)button didEndEditingWithValue:(NSString *)value
{
    [self.priorityButton setTitle:[NSString stringWithFormat:@"%@    >", value] forState:UIControlStateNormal];
    
    currentPriority = [self getPriorityKey:value];
    if(task != nil)
    {
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
    }

    CGSize size = CGSizeMake(320,10000);
    CGSize labelsize = [priorityButton.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [priorityButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
    
    [delegate loadTaskData];
}

-(void)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (void)selectDueDate
{
    [self.dueDateLabel becomeFirstResponder];
}

- (void)selectPriority
{
    [self.priorityButton becomeFirstResponder];
}

- (BOOL)taskIsFinish
{
    return [statusButton.titleLabel.text isEqualToString:@"完成    >"];
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
    
    currentStatus = [NSNumber numberWithInt: isfinish ? 1 : 0];
    if(task != nil)
    {
        self.task.status = [NSNumber numberWithInt: isfinish ? 1 : 0];
        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                     dataId:self.task.id name:@"iscompleted"
                                      value:isfinish ? @"true" : @"false"
                                     teamId:currentTeamId
                                  projectId:currentProjectId
                                   memberId:currentMemberId
                                        tag:currentTag];
        [taskDao commitData];
    }
    
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
    teamTaskOptionViewController.delegate = self;
    
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
    teamTaskOptionViewController.delegate = self;
    
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
    teamTaskOptionViewController.delegate = self;
    
    [Tools layerTransition:self.navigationController.view from:@"right"];
    [self.navigationController pushViewController:teamTaskOptionViewController animated:NO];
}

- (void)saveTask:(id)sender
{
    if(self.task == nil)
    {
        NSString *guid = [Tools stringWithUUID];
        
        NSString *id = [NSString stringWithFormat:@"temp_%@", guid];
        
        NSDate *currentDate = [NSDate date];
        
        [taskDao addTeamTask:subjectTextField.text
                  createDate:currentDate
              lastUpdateDate:currentDate
                        body:bodyTextView.text
                    isPublic:[Tools BOOLToNSNumber:YES]
                      status:currentStatus
                    priority:currentPriority
                      taskId:id
                     dueDate:currentDueDate
                    editable:[NSNumber numberWithInt:1]
              createMemberId:nil
                  assigneeId:currentAssigneeId
                    projects:currentProjects
                        tags:currentTags
                      teamId:currentTeamId];
        
        [taskIdxDao addTaskIdxByTeam:id
                               byKey:currentPriority
                              teamId:currentTeamId
                           projectId:currentProjectId
                            memberId:currentMemberId
                                 tag:currentTag];
        
        //insert changelog
        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                     dataId:id
                                       name:@"subject"
                                      value:subjectTextField.text
                                     teamId:currentTeamId
                                  projectId:currentProjectId
                                   memberId:currentMemberId
                                        tag:currentTag];
        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                     dataId:id
                                       name:@"body"
                                      value:bodyTextView.text
                                     teamId:currentTeamId
                                  projectId:currentProjectId
                                   memberId:currentMemberId
                                        tag:currentTag];
        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                     dataId:id
                                       name:@"priority"
                                      value:currentPriority
                                     teamId:currentTeamId
                                  projectId:currentProjectId
                                   memberId:currentMemberId
                                        tag:currentTag];
        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                     dataId:id
                                       name:@"duetime"
                                      value:[Tools NSDateToNSString:currentDueDate]
                                     teamId:currentTeamId
                                  projectId:currentProjectId
                                   memberId:currentMemberId
                                        tag:currentTag];
        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                    dataId:id
                                      name:@"iscompleted"
                                     value:[self taskIsFinish] ? @"true" : @"false"
                                    teamId:currentTeamId
                                 projectId:currentProjectId
                                  memberId:currentMemberId
                                       tag:currentTag];
        
        if(currentAssigneeId != nil)
        {       
            [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                         dataId:id
                                           name:@"assigneeid"
                                          value:currentAssigneeId
                                         teamId:currentTeamId
                                      projectId:currentProjectId
                                       memberId:currentMemberId
                                            tag:currentTag];
        }
        if(currentProjects != nil)
        {
            NSMutableArray *currentProjectArray = [currentProjects JSONValue];
            for (NSMutableDictionary *currentProjectDict in currentProjectArray)
            {    
                [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:2]
                                             dataId:id
                                               name:@"projects"
                                              value:[currentProjectDict objectForKey:@"id"]
                                             teamId:currentTeamId
                                          projectId:currentProjectId
                                           memberId:currentMemberId
                                                tag:currentTag];
            }
        }
        if(currentTags != nil)
        {
            NSMutableArray *currentTagArray = [currentTags JSONValue];
            for (NSString *currentTagName in currentTagArray)
            {
                [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:2]
                                             dataId:id
                                               name:@"tags"
                                              value:currentTagName
                                             teamId:currentTeamId
                                          projectId:currentProjectId
                                           memberId:currentMemberId
                                                tag:currentTag];
            }
        }
        
        [taskDao commitData];
    }
    else
    {
        [taskDao updateTaskByTeam:self.task
                          subject:subjectTextField.text
                   lastUpdateDate:[NSDate date]
                             body:bodyTextView.text
                         isPublic:[Tools BOOLToNSNumber:YES]
                           status:currentStatus
                         priority:currentPriority
                          dueDate:currentDueDate
                         assignee:currentAssigneeId
                         projects:currentProjects
                             tags:currentTags
                           teamId:currentTeamId
                        projectId:currentProjectId
                         memberId:currentMemberId
                              tag:currentTag];
        
        if(![oldPriority isEqualToString:currentPriority])
        {
            [taskIdxDao updateTaskIdxByTeam:self.task.id
                                      byKey:self.task.priority
                                     teamId:currentTeamId
                                  projectId:currentProjectId
                                   memberId:currentMemberId
                                        tag:currentTag];
        }
        
        //update changelog
        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                     dataId:self.task.id
                                       name:@"subject"
                                      value:subjectTextField.text
                                     teamId:currentTeamId
                                  projectId:currentProjectId
                                   memberId:currentMemberId
                                        tag:currentTag];
        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                     dataId:self.task.id
                                       name:@"body"
                                      value:bodyTextView.text
                                     teamId:currentTeamId
                                  projectId:currentProjectId
                                   memberId:currentMemberId
                                        tag:currentTag];
        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                     dataId:self.task.id
                                       name:@"priority"
                                      value:currentPriority
                                     teamId:currentTeamId
                                  projectId:currentProjectId
                                   memberId:currentMemberId
                                        tag:currentTag];
        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                     dataId:self.task.id
                                       name:@"duetime"
                                      value:[Tools NSDateToNSString:currentDueDate]
                                     teamId:currentTeamId
                                  projectId:currentProjectId
                                   memberId:currentMemberId
                                        tag:currentTag];
        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                     dataId:self.task.id
                                       name:@"iscompleted"
                                      value:[self taskIsFinish] ? @"true" : @"false"
                                     teamId:currentTeamId
                                  projectId:currentProjectId
                                   memberId:currentMemberId
                                        tag:currentTag];
        
        [taskDao commitData];
    }
    
    [self goBack:nil];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"height:%f",textView.contentSize.height);
    
    CGFloat totalheight = bodyTextView.contentSize.height;
    
    //    CGPoint center = viewCenter;
    
    //    float height = 116.0 + [Tools screenMaxHeight] - 480;
    //    if(totalheight > height)
    //    {
    //        CGFloat line = (totalheight - height) / 50.0;
    //
    //
    //        center.y -= 256 + 50 * line;
    //        center.y += 120.0f;
    //        self.view.center = center;
    //    }
    //    else {
    //        center.y -= 256;
    //        center.y += 120.0f;
    //        self.view.center = center;
    //    }
    
    //TODO:目前是无效的，后面处理
    [bodyScrollView setContentSize:bodyTextView.contentSize];
    
    CGRect rect = bodyCell.frame;
    rect.size.height = totalheight;
    bodyCell.frame = rect;
    
    return YES;
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
    center.y += 120.0f;
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

- (void)modifyAssignee:(NSString*)assignee
{
    currentAssigneeId = assignee;
}
- (void)modifyProjects:(NSString*)projects
{
    currentProjects = projects;
}
- (void)modifyTags:(NSString*)tags
{
    currentTags = tags;
}

@end
