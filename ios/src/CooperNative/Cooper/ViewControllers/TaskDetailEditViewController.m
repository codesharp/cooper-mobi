//
//  TaskDetailEditViewController.m
//  Cooper
//
//  Created by Ping Li on 12-7-26.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskDetailEditViewController.h"

@implementation TaskDetailEditViewController

@synthesize task;
@synthesize subjectTextField;
@synthesize dueDateLabel;
@synthesize priorityButton;
@synthesize statusButton;
@synthesize bodyTextView;
@synthesize bodyScrollView;
@synthesize delegate;
@synthesize currentTasklistId;
@synthesize currentIsCompleted;
@synthesize currentDueDate;
@synthesize currentPriority;
@synthesize bodyCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

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
    //[tempTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    //tempTableView.scrollEnabled = NO;
    tempTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tempTableView setBackgroundColor:[UIColor whiteColor]];
    
    //去掉底部空白
    UIView *footer =
    [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    tempTableView.tableFooterView = footer;
    
    detailView = tempTableView;
    
    [detailView setAllowsSelection:NO];
    
    [self.view addSubview: detailView];
    detailView.delegate = self;
    detailView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

- (void)goBack:(id)sender
{
    [delegate loadTaskData];
    
    if(self.task == nil)
        [self.navigationController dismissModalViewControllerAnimated:YES];
    else {
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
}

- (void)saveTask:(id)sender
{
    if(self.task == nil)
    {
        NSString *guid = [Tools stringWithUUID];
        
        NSString *id = [NSString stringWithFormat:@"temp_%@", guid];
        
        NSDate *currentDate = [NSDate date];
        
        [taskDao addTask:subjectTextField.text 
              createDate:currentDate
          lastUpdateDate:currentDate
                    body:bodyTextView.text 
                isPublic:[Tools BOOLToNSNumber:YES] 
                  status:[Tools BOOLToNSNumber:[self taskIsFinish]] 
                priority:self.currentPriority 
                  taskid:id
                 dueDate:self.currentDueDate 
                editable:[NSNumber numberWithInt:1]
              tasklistId:currentTasklistId
                isCommit:NO];
        
        [taskIdxDao addTaskIdx:id 
                         byKey:self.currentPriority 
                    tasklistId:currentTasklistId 
                      isCommit:NO];
        
        //insert changelog
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] 
                               dataid:id 
                                 name:@"subject" 
                                value:subjectTextField.text 
                           tasklistId:self.currentTasklistId];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] 
                               dataid:id name:@"body" 
                                value:bodyTextView.text 
                           tasklistId:self.currentTasklistId];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] 
                               dataid:id 
                                 name:@"priority" 
                                value:self.currentPriority 
                           tasklistId:self.currentTasklistId];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] 
                               dataid:id 
                                 name:@"duetime" 
                                value:[Tools NSDateToNSString:self.currentDueDate] 
                           tasklistId:self.currentTasklistId];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] 
                               dataid:id 
                                 name:@"iscompleted" 
                                value:[self taskIsFinish] ? @"true" : @"false" 
                           tasklistId:self.currentTasklistId];
        
        [taskDao commitData];
    }
    else 
    {
        [taskDao updateTask:self.task 
                    subject:subjectTextField.text 
             lastUpdateDate:[NSDate date] 
                       body:bodyTextView.text 
                   isPublic:[Tools BOOLToNSNumber:YES] 
                     status:[Tools BOOLToNSNumber:[self taskIsFinish]] 
                   priority:self.currentPriority 
                    dueDate:self.currentDueDate
                 tasklistId:self.currentTasklistId
                   isCommit:NO];
        
        if(![oldPriority isEqualToString:self.currentPriority])
            [taskIdxDao updateTaskIdx:self.task.id 
                                byKey:self.task.priority 
                           tasklistId:self.currentTasklistId
                             isCommit:NO];
        
        //update changelog
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] 
                               dataid:self.task.id 
                                 name:@"subject" 
                                value:subjectTextField.text
                           tasklistId:currentTasklistId];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] 
                               dataid:self.task.id 
                                 name:@"body" 
                                value:bodyTextView.text 
                           tasklistId:currentTasklistId];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] 
                               dataid:self.task.id 
                                 name:@"priority" 
                                value:self.currentPriority
                           tasklistId:currentTasklistId];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] 
                               dataid:self.task.id 
                                 name:@"duetime" 
                                value:[Tools NSDateToNSString:self.currentDueDate]
                           tasklistId:currentTasklistId];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] 
                               dataid:self.task.id 
                                 name:@"iscompleted" 
                                value:[self taskIsFinish] ? @"true" : @"false"
                           tasklistId:currentTasklistId];
        
        [taskDao commitData];
    }
    
    [self goBack:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    taskDao = [[TaskDao alloc] init];
    taskIdxDao = [[TaskIdxDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
    
    self.currentDueDate = nil;
    self.currentIsCompleted = NO;
    self.currentPriority = @"0";
    
    [self initContentView];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) dealloc
{
    [super dealloc];
    
    [subjectTextField release];
    [bodyTextView release];
    [priorityButton release];
    [statusButton release];
    [dueDateLabel release];
    [bodyCell release];
    [task release];
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
    return 5;
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
            
            CGSize size = CGSizeMake([Tools screenMaxWidth], 10000);
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
                
                UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDueDate)];
                [self.dueDateLabel addGestureRecognizer:recog];
                self.dueDateLabel.delegate = self;
                [recog release];
            }
            if(self.task != nil)
            {   
                if (task.dueDate == nil) {
                    [self.dueDateLabel setTitle:@"请选择    >" forState:UIControlStateNormal];
                }
                else
                {
                    [self.dueDateLabel setTitle:[NSString stringWithFormat:@"%@    >", [Tools ShortNSDateToNSString:task.dueDate]] forState:UIControlStateNormal];
                    
                    self.currentDueDate = task.dueDate;
                }
            }
            else
            {
                [self.dueDateLabel setTitle:@"请选择    >" forState:UIControlStateNormal];
            }
            
            CGSize size = CGSizeMake([Tools screenMaxWidth], 10000);
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
                
                UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPriority)];
                [priorityButton addGestureRecognizer:recog];
                priorityButton.delegate = self;
                [recog release];
                
                [priorityButton setTitle:[NSString stringWithFormat:@"%@    >", PRIORITY_TITLE_1] forState:UIControlStateNormal];
            }
            
            if(self.task != nil)
            {   
                [priorityButton setTitle: [NSString stringWithFormat:@"%@    >", [self getPriorityValue:task.priority]] forState:UIControlStateNormal];
                oldPriority = [task.priority copy];
            }
            
            CGSize size = CGSizeMake([Tools screenMaxWidth], 10000);
            CGSize labelsize = [priorityButton.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            [priorityButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
            [cell.contentView addSubview:priorityButton];
        }
        else if(indexPath.row == 3)
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
        else if(indexPath.row == 4)
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
    if(indexPath.row == 4)
    {
        UITableViewCell *cell = (UITableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    return 44.0f;
}

- (void)tableViewCell:(DateLabel *)label didEndEditingWithDate:(NSDate *)value
{
    [self.dueDateLabel setTitle:[NSString stringWithFormat:@"%@    >", [Tools ShortNSDateToNSString:value]] forState:UIControlStateNormal];
    
    self.currentDueDate = value;
    if(task != nil)
    {
        task.dueDate = value;
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] 
                               dataid:self.task.id 
                                 name:@"duetime" 
                                value:[Tools ShortNSDateToNSString:value] 
                           tasklistId:currentTasklistId];   
        [taskDao commitData];  
        //[delegate loadTaskData];
    }
    
    CGSize size = CGSizeMake([Tools screenMaxWidth], 10000);
    CGSize labelsize = [dueDateLabel.titleLabel.text sizeWithFont:dueDateLabel.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [dueDateLabel setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
}

- (void)tableViewCell:(PriorityButton *)button didEndEditingWithValue:(NSString *)value
{
    [self.priorityButton setTitle:[NSString stringWithFormat:@"%@    >", value] forState:UIControlStateNormal];
    
    self.currentPriority = [self getPriorityKey:value];
    if(task != nil)
    {
        task.priority = self.currentPriority;
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
        
        [delegate loadTaskData];
    }
    
    CGSize size = CGSizeMake([Tools screenMaxWidth], 10000);
    CGSize labelsize = [priorityButton.titleLabel.text sizeWithFont:priorityButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [priorityButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
    
    
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
    
    self.currentIsCompleted = isfinish;
    if(task != nil)
    {
        self.task.status = [NSNumber numberWithInt: isfinish ? 1 : 0];
        
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] 
                               dataid:self.task.id 
                                 name:@"iscompleted" 
                                value:isfinish ? @"true" : @"false" 
                           tasklistId:currentTasklistId];
        
        [taskDao commitData];
        
        [delegate loadTaskData];
    }
    
    CGSize size = CGSizeMake([Tools screenMaxWidth],10000);
    CGSize labelsize = [statusButton.titleLabel.text sizeWithFont:statusButton.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [statusButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)]; 
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

@end
