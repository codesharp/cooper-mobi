//
//  TaskDetailEditViewController.m
//  Cooper
//
//  Created by Ping Li on 12-7-26.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "TaskDetailEditViewController.h"

@interface TaskDetailEditViewController ()

@end

@implementation TaskDetailEditViewController

@synthesize task;
@synthesize subjectTextField;
@synthesize dueDateLabel;
@synthesize priorityButton;
@synthesize statusButton;
@synthesize bodyTextView;
@synthesize delegate;
@synthesize currentTasklistId;
@synthesize currentIsCompleted;
@synthesize currentDueDate;
@synthesize currentPriority;

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
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtn] autorelease];
    self.navigationItem.leftBarButtonItem = backButtonItem;

    CustomButton *saveTaskBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(5,5,50,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
    saveTaskBtn.layer.cornerRadius = 6.0f;
    [saveTaskBtn.layer setMasksToBounds:YES];
    [saveTaskBtn addTarget:self action:@selector(saveTask:) forControlEvents:UIControlEventTouchUpInside];
    [saveTaskBtn setTitle:@"确认" forState:UIControlStateNormal];
    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithCustomView:saveTaskBtn] autorelease];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    CGRect tableViewRect = CGRectMake(0, 0, 320, 480);
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

- (void)goBack:(id)sender
{
    if(self.task == nil)
        [self.navigationController dismissModalViewControllerAnimated:YES];
    else {
        [self.navigationController dismissModalViewControllerAnimated:NO];
    }
}

- (void)saveTask:(id)sender
{
    if(self.task == nil)
    {
        //TODO:日期格式
        NSString *guid = [Tools stringWithUUID];
        
        NSString *id = [NSString stringWithFormat:@"temp_%@_%@", self.currentPriority, guid];
        
        NSDate *currentDate = [NSDate date];
        
        [taskDao addTask:subjectTextField.text 
              createDate:currentDate
          lastUpdateDate:currentDate
                    body:bodyTextView.text 
                isPublic:[Tools BOOLToNSNumber:YES] 
                  status:[Tools BOOLToNSNumber:self.currentIsCompleted] 
                priority:self.currentPriority 
                  taskid:id
                 dueDate:self.currentDueDate
              tasklistId:currentTasklistId
                isCommit:NO];
        
        [taskIdxDao addTaskIdx:id 
                         byKey:self.currentPriority 
                    tasklistId:self.currentTasklistId 
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
                                value:self.currentIsCompleted ? @"true" : @"false" 
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
                     status:[Tools BOOLToNSNumber:self.currentIsCompleted] 
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
                                value:self.currentIsCompleted ? @"true" : @"false"
                           tasklistId:currentTasklistId];
        
        [taskDao commitData];
    }
    
    [self goBack:nil];
    //[self.navigationController dismissModalViewControllerAnimated:YES];
    //[delegate loadTaskData];
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
                
                statusButton = [[CustomButton alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"btn_bg_green.png"]];
                statusButton.userInteractionEnabled = YES;
                
                [statusButton addTarget:self action:@selector(switchStatus) forControlEvents:UIControlEventTouchUpInside];
                
                [statusButton setTitle:@"Open    >" forState:UIControlStateNormal];
            }
            
            if(self.task != nil)
            {   
                [statusButton setTitle: self.task.status == [NSNumber numberWithInt:1] ? @"Close    >" : @"Open    >" forState:UIControlStateNormal];
                [statusButton setBackgroundImage:[UIImage imageNamed:self.task.status == [NSNumber numberWithInt:1] ? @"btn_bg_gray.png" : @"btn_bg_green.png"] forState:UIControlStateNormal];
                [statusButton setTitleColor: self.task.status == [NSNumber numberWithInt:1] ?[UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
            }
            
            CGSize size = CGSizeMake(320,10000);
            CGSize labelsize = [statusButton.titleLabel.text sizeWithFont:[statusButton font] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
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
                    [self.dueDateLabel setTitle:@"          >" forState:UIControlStateNormal];
                }
                else
                {
                    [self.dueDateLabel setTitle:[NSString stringWithFormat:@"%@    >", [Tools ShortNSDateToNSString:task.dueDate]] forState:UIControlStateNormal];
                    
                    self.currentDueDate = task.dueDate;
                }
            }
            
            CGSize size = CGSizeMake(320,10000);
            CGSize labelsize = [dueDateLabel.titleLabel.text sizeWithFont:[dueDateLabel font] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
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
            
            CGSize size = CGSizeMake(320,10000);
            CGSize labelsize = [priorityButton.titleLabel.text sizeWithFont:[priorityButton font] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
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
                
                subjectTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 200, 25)];
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
            cell = [tableView dequeueReusableCellWithIdentifier:@"BodayCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BodayCell"] autorelease];
                
                bodyTextView = [[UITextView alloc] initWithFrame:self.view.frame];
                bodyTextView.userInteractionEnabled = YES;
                [bodyTextView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                [bodyTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
                [bodyTextView setReturnKeyType:UIReturnKeyDone];
                [bodyTextView setTextAlignment:UITextAlignmentLeft];
                bodyTextView.scrollEnabled = YES;//是否可以拖动  
                bodyTextView.delegate = self;
                bodyTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                [cell.contentView addSubview:bodyTextView];
            }
            
            if(task != nil)
            {
                bodyTextView.text = task.body;
            }
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
//    if(indexPath.row == 3)
//    {
//        UITableViewCell *cell = (UITableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//        return cell.frame.size.height;
//    }
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
    
    CGSize size = CGSizeMake(320,10000);
    CGSize labelsize = [dueDateLabel.titleLabel.text sizeWithFont:[dueDateLabel font] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
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
        //[delegate loadTaskData];
    }
    
    CGSize size = CGSizeMake(320,10000);
    CGSize labelsize = [priorityButton.titleLabel.text sizeWithFont:[priorityButton font] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
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

- (void)switchStatus
{
    bool isfinish;
    if([statusButton.titleLabel.text isEqualToString:@"Open    >"])
    {
        [statusButton setTitle:@"Close    >" forState:UIControlStateNormal];
        [statusButton setBackgroundImage:[UIImage imageNamed:@"btn_bg_gray.png"] forState:UIControlStateNormal];
        [statusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        isfinish = YES; 
    }
    else
    {
        [statusButton setTitle:@"Open    >" forState:UIControlStateNormal];
        [statusButton setBackgroundImage:[UIImage imageNamed:@"btn_bg_green.png"] forState:UIControlStateNormal];
        [statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
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
        
        //[delegate loadTaskData];
    }
    
    CGSize size = CGSizeMake(320,10000);
    CGSize labelsize = [statusButton.titleLabel.text sizeWithFont:[statusButton font] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [statusButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)]; 
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
