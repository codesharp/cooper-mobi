//
//  DetailViewController.m
//  Cooper
//
//  Created by sunleepy on 12-6-29.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize task;
@synthesize commentViewController;
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    taskDao = [[TaskDao alloc] init];
    taskIdxDao = [[TaskIdxDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
    
//    NSArray *buttonNames = [NSArray arrayWithObjects:@"编辑", @"注释/评论", nil];
//    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:buttonNames];
//    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//    //segmentedControl.momentary = YES;
//    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
//    self.navigationItem.titleView = segmentedControl;
//    segmentedControl.selectedSegmentIndex = 0;
//    [segmentedControl release];

    // self.clearsSelectionOnViewWillAppear = NO;
 
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(goBack) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveNewObject:)];    
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
}

- (void)segmentAction:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl*)self.navigationItem.titleView;
    NSLog(@"segment num: %d", segmentedControl.selectedSegmentIndex);
    if(segmentedControl.selectedSegmentIndex == 0)
    {
        if(tempView == nil)
            return;
        self.view = tempView;
        [tempView release];
    }
    else {
        if (!self.commentViewController) {
            self.commentViewController = [[[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil] autorelease];
        }
        
        tempView = self.view;
        [tempView retain];
        
        self.view = self.commentViewController.view;
        //[self.navigationController presentModalViewController:self.commentViewController animated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [taskDao release];
    [taskIdxDao release];
    [changeLogDao release];
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) return 1;
    else if(section == 1) return 1;
    else if(section == 2) return 2;
    else if(section == 3) return 1;
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTextFieldCell"];
        if(!cell)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomTextFieldCell"] autorelease];  
            //HACK:目前这样区分ipad和iphone宽度 
            CGFloat width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 660 : 285;
            UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, width, 30)];       
            [field setPlaceholder:@"标题"]; 
            [field setReturnKeyType:UIReturnKeyDone];
            [field addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            [cell.contentView addSubview:field];
        }
        
        //UITextField *textField = (UITextField *)[cell viewWithTag:101];
        UITextField *textField = (UITextField*)[cell.contentView.subviews objectAtIndex:0];
        
        [textField setSelected:TRUE];
        
        if(self.task != nil)
        {
            
            [textField setText:self.task.subject == [NSNull null] ? @"" : self.task.subject];
        }
    }
    else if(indexPath.section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTextViewCell"];
        if(!cell)
        {
            //cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomTextViewCell" owner:self options:nil] lastObject];
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomTextViewCell"] autorelease];      

            //HACK:目前这样区分ipad和iphone宽度 
            CGFloat width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 660 : 285;
            UITextView *field = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, width, 75 )];       
            [field setReturnKeyType:UIReturnKeyDone];
            field.delegate = self;
            field.backgroundColor = [UIColor clearColor];
            [field setFont:[UIFont boldSystemFontOfSize:15]];
            [cell.contentView addSubview:field];
        }
        
        //UITextView *textView = [(UITextView*)cell viewWithTag:102];
        UITextView *textView = (UITextView*)[cell.contentView.subviews objectAtIndex:0];
        if(self.task != nil)
            [textView setText:self.task.body == [NSNull null] ? @"" : self.task.body];
    }
    else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"EndDateCell"];
            if(!cell)
                cell = [[[NSBundle mainBundle] loadNibNamed:@"EndDateCell" owner:self options:nil] lastObject];
            
            cell.detailTextLabel.text = [Tools ShortNSDateToNSString:[NSDate date]];   
            cell.textLabel.text = @"截至日期";
            if(self.task != nil)
                cell.detailTextLabel.text = [Tools ShortNSDateToNSString:task.dueDate]; 
        }
        else if(indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PriorityCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PriorityCell"] autorelease];
            }
            cell.textLabel.text = @"优先级";
            cell.detailTextLabel.text = @"今天";
            
            if(self.task != nil)
            {
                cell.detailTextLabel.text = [self getPriorityValue:task.priority];
                oldPriority = [task.priority copy];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.editingAccessoryType = UITableViewCellAccessoryNone; 
        }
    }
    else if(indexPath.section == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CustomSwitchCell"];
        if(!cell)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CustomSwitchCell"] autorelease];
            
            UISwitch *uiSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
            cell.accessoryView = uiSwitch;
            [uiSwitch release];
        }

        if(indexPath.row == 0)
        {
            UISwitch *uiSwitch = (UISwitch*)cell.accessoryView;
            if(self.task != nil)
            {
                
                [uiSwitch setOn:[task.status boolValue]];
            }
            else 
            {
                [uiSwitch setOn:NO];
            }
            cell.textLabel.text = @"完成";
        }
    }
    else{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SubtitleCell"] autorelease];
        cell.textLabel.text = @"Hello World";
        cell.detailTextLabel.text = @"Subtitle World";
    }
    
    return cell;
}
//点击右侧箭号
- (void) tableView:(UITableView*)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{  

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2 && indexPath.row == 1)
    {
        PriorityViewController *priorityController = [[[PriorityViewController alloc] initWithNibName:@"PriorityViewController" bundle:nil] autorelease];

        UITableView *tv = self.view;
        UITableViewCell *cell = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];

        [priorityController setCurrentcell:cell];
        [self.navigationController pushViewController:priorityController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) return 40.0f;
    if(indexPath.section == 1) return 90.0f;
    else {
        return 40.0f;
    }
    return 0.0f;
}

- (void)saveNewObject:(id)sender
{    
    UITableView *tv = self.view;
    UITableViewCell *cell1 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //UITextField *textTitle = (UITextField *)[cell1 viewWithTag:101];
    UITextField *textTitle = (UITextField *)[cell1.contentView.subviews objectAtIndex:0];
    
    UITableViewCell *cell2 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //UITextView *textNote = (UITextView*)[cell2 viewWithTag:102];
    UITextView *textNote = (UITextView*)[cell2.contentView.subviews objectAtIndex:0];
    
    UITableViewCell *cell3 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    //UITextField *textEndDate = (UITextField*)[cell3 viewWithTag:103];
    NSString* endDateString = cell3.detailTextLabel.text;
    
    UITableViewCell *cell3_1 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    NSString *priorityString = cell3_1.detailTextLabel.text; 
    
    //UITableViewCell *cell4 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    //UISwitch *switchIsPublic = (UISwitch*)[cell4 viewWithTag:105];
    
    UITableViewCell *cell5 = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    UISwitch *switchIsFinish = (UISwitch*)cell5.accessoryView;
    
    //BOOL isPublic = switchIsPublic.isOn;
    BOOL isfinish = switchIsFinish.isOn;

NSManagedObjectContext *context =nil;
    if(self.task == nil)
    {
        NSString *priorityKey = [self getPriorityKey:priorityString];

        NSLog(@"priority:%@", priorityKey);
        
        //TODO:日期格式
        NSString *dateString = [Tools NSDateToNSString:[NSDate date]];

        
        NSString *id = [NSString stringWithFormat:@"temp_%@_%@", priorityKey, dateString];
        
        NSData *dueDate = [Tools NSStringToShortNSDate:endDateString];
        
        NSDate *currentDate = [NSDate date];
        
        [taskDao addTask:textTitle.text 
              createDate:currentDate
          lastUpdateDate:currentDate
                    body:textNote.text 
                isPublic:[Tools BOOLToNSNumber:YES] 
                  status:[Tools BOOLToNSNumber:isfinish] 
                priority:priorityKey 
                  taskid:id
                 dueDate:dueDate 
                isCommit:NO];
        
        [taskIdxDao addTaskIdx:id byKey:priorityKey isCommit:NO];
        
        //insert changelog
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] dataid:id name:@"subject" value:textTitle.text];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] dataid:id name:@"body" value:textNote.text];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] dataid:id name:@"priority" value:priorityKey];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] dataid:id name:@"duetime" value:endDateString];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] dataid:id name:@"iscompleted" value:isfinish ? @"true" : @"false"];
        
        [taskDao commitData];
    }
    else {   
        
        NSString *priorityKey = [self getPriorityKey:priorityString];
        NSLog(@"priority:%@ %@", priorityString, priorityKey);
        NSDate *dueDate = [Tools NSStringToShortNSDate:endDateString];
        
        [taskDao updateTask:self.task 
                    subject:textTitle.text 
             lastUpdateDate:[NSDate date] 
                       body:textNote.text 
                   isPublic:[Tools BOOLToNSNumber:YES] 
                     status:[Tools BOOLToNSNumber:isfinish] 
                   priority:priorityKey 
                    dueDate:dueDate 
                   isCommit:NO];
        
        if(![oldPriority isEqualToString:priorityKey])
            [taskIdxDao updateTaskIdx:self.task.id byKey:self.task.priority isCommit:NO];
        
        //update changelog
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] dataid:self.task.id name:@"subject" value:textTitle.text];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] dataid:self.task.id name:@"body" value:textNote.text];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] dataid:self.task.id name:@"priority" value:priorityKey];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] dataid:self.task.id name:@"duetime" value:endDateString];
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] dataid:self.task.id name:@"iscompleted" value:isfinish ? @"true" : @"false"];
        
        [taskDao commitData];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [delegate loadTaskData];
}

-(void)textFieldDoneEditing:(id)sender
{
    NSLog(@"doneEditing");
    [sender resignFirstResponder];
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
