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
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(saveTask:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    CGRect tableViewRect = CGRectMake(0, 0, 320, 380);
    UITableView* tempTableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    //[tempTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    //tempTableView.scrollEnabled = NO;
    tempTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tempTableView setBackgroundColor:[UIColor whiteColor]];
    
    //去掉底部空白
    UIView *footer =
    [[UIView alloc] initWithFrame:CGRectZero];
    tempTableView.tableFooterView = footer;
    [footer release];
    
    detailView = tempTableView;
    
    [detailView setAllowsSelection:NO];
    
    [self.view addSubview: detailView];
    detailView.delegate = self;
    detailView.dataSource = self;
}

- (void)goBack:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)saveTask:(id)sender
{
    
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
                    [self.dueDateLabel setTitle:[NSString stringWithFormat:@"%@    >", [Tools ShortNSDateToNSString:task.dueDate]] forState:UIControlStateNormal];
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
                
                [priorityButton setTitle:@"今天    >" forState:UIControlStateNormal];
            }
            
            if(self.task != nil)
            {   
                [priorityButton setTitle: [NSString stringWithFormat:@"%@    >", [self getPriorityValue:task.priority]] forState:UIControlStateNormal];
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
                cell.textLabel.text = @"主题:";
                [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                
                subjectTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 200, 25)];
                subjectTextField.userInteractionEnabled = YES;
                [subjectTextField setReturnKeyType:UIReturnKeyDone];
                [subjectTextField setTextAlignment:UITextAlignmentLeft];
                [subjectTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                [subjectTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
                [subjectTextField setPlaceholder:@"主题"];
                [subjectTextField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:subjectTextField];
            }
            
            if(task != nil)
            {
                subjectTextField.text = task.subject;
            }
        }
        else if(indexPath.row == 4)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SubjectCell"] autorelease];
                cell.textLabel.text = @"备注:";
                [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                
                bodyTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 40, 320, 25)];
                bodyTextView.userInteractionEnabled = YES;
                [bodyTextView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                [bodyTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
                [bodyTextView setReturnKeyType:UIReturnKeyDone];
                [bodyTextView setTextAlignment:UITextAlignmentLeft];
                [cell.contentView addSubview:bodyTextView];
            }
            
            if(task != nil)
            {
                bodyTextView.text = task.body;
            }
        }
//        else if(indexPath.row == 3)
//        {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"SubjectBodyCell"];
//            if(!cell)
//            {
//                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SubjectBodyCell"] autorelease];                
//                
//                self.subjectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//                subjectLabel.userInteractionEnabled = YES;
//                [subjectLabel setLineBreakMode:UILineBreakModeWordWrap];
//                [subjectLabel setFont:[UIFont boldSystemFontOfSize:16]];
//                [cell addSubview:subjectLabel];     
//                
//                self.bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//                bodyLabel.userInteractionEnabled = YES;
//                [bodyLabel setTextColor:[UIColor grayColor]];
//                [bodyLabel setFont:[UIFont systemFontOfSize:14]];
//                [subjectLabel setLineBreakMode:UILineBreakModeWordWrap];
//                [cell addSubview:bodyLabel];
//            }
//            
//            if(task.subject != nil)
//            {
//                subjectLabel.text = task.subject;
//            } 
//            if(task.body != nil)
//            {
//                bodyLabel.text = task.body;
//            }
//            
//            CGSize subjectLabelSize = [subjectLabel.text sizeWithFont:subjectLabel.font 
//                                                    constrainedToSize:CGSizeMake(280, 10000) 
//                                                        lineBreakMode:UILineBreakModeWordWrap];
//            
//            CGFloat subjectLabelHeight = subjectLabelSize.height;
//            
//            int subjectlines = subjectLabelHeight / 16;
//            [subjectLabel setFrame:CGRectMake(20, 5, 280, subjectLabelHeight)];
//            [subjectLabel setNumberOfLines:subjectlines];
//            
//            CGSize bodyLabelSize = [bodyLabel.text sizeWithFont:bodyLabel.font 
//                                              constrainedToSize:CGSizeMake(320, 10000) 
//                                                  lineBreakMode:UILineBreakModeWordWrap];
//            
//            CGFloat bodyLabelHeight = bodyLabelSize.height;
//            
//            int bodylines = bodyLabelHeight / 16;
//            [bodyLabel setFrame:CGRectMake(20, bodyLabelHeight + 10, 280, bodyLabelHeight)];
//            [bodyLabel setNumberOfLines:bodylines];
//            
//            [cell setFrame:CGRectMake(0, 0, 320, bodyLabelHeight + subjectLabelHeight + 15)];
//        }
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
    
    task.dueDate = value;
    
    [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] dataid:self.task.id name:@"duetime" value:[Tools ShortNSDateToNSString:value]];
    
    [taskDao commitData];
    
    CGSize size = CGSizeMake(320,10000);
    CGSize labelsize = [dueDateLabel.titleLabel.text sizeWithFont:[dueDateLabel font] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [dueDateLabel setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
    
    [delegate loadTaskData];
}

- (void)tableViewCell:(PriorityButton *)button didEndEditingWithValue:(NSString *)value
{
    [self.priorityButton setTitle:[NSString stringWithFormat:@"%@    >", value] forState:UIControlStateNormal];
    
    task.priority = [self getPriorityKey:value];
    [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] dataid:self.task.id name:@"priority" value:task.priority];
    [taskIdxDao updateTaskIdx:self.task.id byKey:self.task.priority isCommit:NO];
    
    [taskDao commitData];
    
    CGSize size = CGSizeMake(320,10000);
    CGSize labelsize = [priorityButton.titleLabel.text sizeWithFont:[priorityButton font] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
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
    
    self.task.status = [Tools BOOLToNSNumber:isfinish];
    
    [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] dataid:self.task.id name:@"iscompleted" value:isfinish ? @"true" : @"false"];
    
    [taskDao commitData];
    
    CGSize size = CGSizeMake(320,10000);
    CGSize labelsize = [statusButton.titleLabel.text sizeWithFont:[statusButton font] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [statusButton setFrame:CGRectMake(110, 8, labelsize.width + 40, labelsize.height + 10)];
    
    [delegate loadTaskData];
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
    if([priorityValue isEqualToString:@"今天"])
        return @"0";
    else if([priorityValue isEqualToString:@"稍后完成"])
        return @"1";
    else if([priorityValue isEqualToString:@"迟些再说"])
        return @"2";
    return @"0";
}
- (NSString*)getPriorityValue:(NSString*)priorityKey
{
    if([priorityKey isEqualToString:@"0"])
        return @"今天";
    else if([priorityKey isEqualToString:@"1"])
        return @"稍后完成";
    else if([priorityKey isEqualToString:@"2"])
        return @"迟些再说";
    return @"今天";
}

@end
