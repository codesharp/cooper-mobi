//
//  TasklistEditController.m
//  Cooper
//
//  Created by sunleepy on 12-7-29.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "TasklistEditController.h"
#import "CustomButton.h"

@implementation TasklistEditController

@synthesize nameTextField;

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
    [saveTaskBtn addTarget:self action:@selector(saveTasklist:) forControlEvents:UIControlEventTouchUpInside];
    [saveTaskBtn setTitle:@"确认" forState:UIControlStateNormal];
    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithCustomView:saveTaskBtn] autorelease];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    CGRect tableViewRect = CGRectMake(0, 0, 320, 480);
    UITableView* tempTableView = [[[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain] autorelease];
    tempTableView.scrollEnabled = NO;
    tempTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tempTableView setBackgroundColor:[UIColor whiteColor]];
    
    //去掉底部空白
    UIView *footer =
    [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    tempTableView.tableFooterView = footer;
    
    tasklistTableView = tempTableView;
    
    [tasklistTableView setAllowsSelection:NO];
    
    [self.view addSubview: tasklistTableView];
    tasklistTableView.delegate = self;
    tasklistTableView.dataSource = self;
}

- (void)goBack:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)saveTasklist:(id)sender
{
    if([nameTextField.text length] == 0)
    {
        [Tools alert:@"请输入任务表名称"];
        return;
    }
    
    NSString *dateString = [Tools NSDateToNSString:[NSDate date]];
    NSString *guid = [Tools stringWithUUID];
    
    NSString *id = [NSString stringWithFormat:@"temp_%@", guid];
    [tasklistDao addTasklist:id :nameTextField.text :@"per"];
    
    //TODO:add changelog
    
    [tasklistDao commitData];
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tasklistDao = [[TasklistDao alloc] init];
    [self initContentView];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    RELEASE(nameTextField);
    RELEASE(tasklistTableView);
}

- (void) dealloc
{
    [super dealloc];
    RELEASE(tasklistDao);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

//获取TableView的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//获取在制定的分区编号下的纪录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//填充单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"NameCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"NameCell"] autorelease];
                cell.textLabel.text = @"任务表";
                [cell.textLabel setTextColor:[UIColor grayColor]];[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                
                nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 200, 25)];
                nameTextField.userInteractionEnabled = YES;
                
                [nameTextField setReturnKeyType:UIReturnKeyDone];
                [nameTextField setTextAlignment:UITextAlignmentLeft];
                [nameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                [nameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
                [nameTextField setPlaceholder:@"任务表"];
                [nameTextField addTarget:self action:@selector(textFieldDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
                [cell.contentView addSubview:nameTextField];
            }
        }
        else 
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"UnknownCell"];
            
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UnknownCell"] autorelease];                      
            }  
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

@end
