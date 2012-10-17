//
//  TeamTaskFilterViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-9-20.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TeamTaskFilterViewController.h"
#import "CustomButton.h"

@implementation TeamTaskFilterViewController

@synthesize delegate;
@synthesize teamTaskFilterLabel;
@synthesize currentTeamId;
@synthesize filterOptionArray;

#pragma mark - UI相关

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
    
    teamMemberDao = [[TeamMemberDao alloc] init];
    projectDao = [[ProjectDao alloc] init];
    tagDao = [[TagDao alloc] init];
    filterOptionArray = [NSMutableArray array];
    
    currentIndex = -1;
	
    [self initContentView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void) dealloc
{
    [super dealloc];
    [teamTaskFilterLabel release];
    [filterOptionView release];
    [scrollView release];
    [teamMemberDao release];
    [projectDao release];
    [tagDao release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - tableView 数据源

//获取TableView的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//获取在制定的分区编号下的纪录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == filterView)
        return 1;
    else if(tableView == filterOptionView)
        return filterOptionArray.count;
    return 0;
}
//填充单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(tableView == filterView)
    {
        if(indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"FilterCell"] autorelease];
                cell.textLabel.text = @"选项:";
                [cell.textLabel setTextColor:[UIColor grayColor]];
                [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
                
                teamTaskFilterLabel = [[TeamTaskFilterLabel alloc] initWithFrame:CGRectMake(110, 8, [Tools screenMaxWidth] - 110, 30)];
                teamTaskFilterLabel.text = @"默认";
                teamTaskFilterLabel.backgroundColor = [UIColor clearColor];
                teamTaskFilterLabel.userInteractionEnabled = YES;
                UITapGestureRecognizer *recoginzer = [[UITapGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(selectFilter:)];
                [teamTaskFilterLabel addGestureRecognizer:recoginzer];
                teamTaskFilterLabel.delegate = self;
                [recoginzer release];
                
                [cell.contentView addSubview:teamTaskFilterLabel];     
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
    else if(tableView == filterOptionView)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FilterOptionCell"];
        if(!cell)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterOptionCell"] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.row == currentIndex)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        NSObject *idObject = [filterOptionArray objectAtIndex:indexPath.row];
        if([idObject isKindOfClass:[TeamMember class]])
        {
            TeamMember *teamMember = (TeamMember*)idObject;
            cell.textLabel.text = teamMember.name;
        }
        else if([idObject isKindOfClass:[Project class]])
        {
            Project *project = (Project*)idObject;
            cell.textLabel.text = project.name;
        }
        else if([idObject isKindOfClass:[Tag class]])
        {
            Tag *tag = (Tag*)idObject;
            cell.textLabel.text = tag.name;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    if(tableView == filterOptionView)
    {
        if(indexPath.row == currentIndex)
        {
            return;
        }
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        if (newCell.accessoryType == UITableViewCellAccessoryNone) {
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
        if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            oldCell.accessoryType = UITableViewCellAccessoryNone;
        }
        currentIndex=indexPath.row;
        
        NSObject *idObject = [filterOptionArray objectAtIndex:indexPath.row];
        if([idObject isKindOfClass:[TeamMember class]])
        {
            TeamMember *teamMember = (TeamMember*)idObject;
            
            currentProjectId = nil;
            currentMemberId = teamMember.id;
            currentTag = nil;
        }
        else if([idObject isKindOfClass:[Project class]])
        {
            Project *project = (Project*)idObject;
            
            currentProjectId = project.id;
            currentMemberId = nil;
            currentTag = nil;
        }
        else if([idObject isKindOfClass:[Tag class]])
        {
            Tag *tag = (Tag*)idObject;
            
            currentProjectId = nil;
            currentMemberId = nil;
            currentTag = tag.name;
        }
    }
}

#pragma mark - TeamTaskViewDelegate 事件

- (void)tableViewCell:(TeamTaskFilterLabel *)label didEndEditingWithValue:(NSString *)value
{
    [self doneFilterCallback:label withValue:value];
}

- (void)doneFilterCallback:(TeamTaskFilterLabel*)label withValue:(NSString*)value
{
    label.text = value;
    
    currentIndex = -1;
    if([label.text isEqualToString:@"按执行人"])
    {
        filterOptionArray = [teamMemberDao getListByTeamId:currentTeamId];
        
        [self createFilterOptionView];
        
    }
    else if([label.text isEqualToString:@"按项目"])
    {
        filterOptionArray = [projectDao getListByTeamId:currentTeamId];
        
        [self createFilterOptionView];
    }
    else if([label.text isEqualToString:@"按标签"])
    {
        filterOptionArray = [tagDao getListByTeamId:currentTeamId];
        
        [self createFilterOptionView];
    }
    else
    {
        //默认
        if(filterOptionView)
        {
            [filterOptionView removeFromSuperview];
            filterOptionView = nil;
            scrollView.frame = CGRectZero;
        }
        
        currentProjectId = nil;
        currentMemberId = nil;
        currentTag = nil;
    }
}

#pragma mark - 事件动作

- (void)initContentView
{
    self.title = @"条件筛选";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:BACK_IMAGE] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(back:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtn] autorelease];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    CustomButton *saveTaskBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(5,5,50,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
    saveTaskBtn.layer.cornerRadius = 6.0f;
    [saveTaskBtn.layer setMasksToBounds:YES];
    [saveTaskBtn addTarget:self action:@selector(saveFilter:) forControlEvents:UIControlEventTouchUpInside];
    [saveTaskBtn setTitle:@"确定" forState:UIControlStateNormal];
    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithCustomView:saveTaskBtn] autorelease];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    CGRect tableViewRect = CGRectMake(0, 0, [Tools screenMaxWidth], [Tools screenMaxHeight]);
    UITableView* tempTableView = [[[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain] autorelease];
    tempTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //去掉底部空白
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    tempTableView.tableFooterView = footer;
    
    filterView = tempTableView;
    
    filterView.allowsSelection = NO;
    filterView.scrollEnabled = NO;
    
    [self.view addSubview: filterView];
    filterView.delegate = self;
    filterView.dataSource = self;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
}

- (void)createFilterOptionView
{
    if(filterOptionView == nil)
    {
        CGRect tableViewRect = CGRectMake(0, 0, [Tools screenMaxWidth], [Tools screenMaxHeight] - 84);
        UITableView* tempTableView = [[[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain] autorelease];
        tempTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [tempTableView setBackgroundColor:[UIColor whiteColor]];
        
        //去掉底部空白
        UIView *footer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        tempTableView.tableFooterView = footer;
        filterOptionView = tempTableView;
        filterOptionView.delegate = self;
        filterOptionView.dataSource = self;
    }
    else
    {
        [filterOptionView reloadData];
    }
    
    scrollView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
    scrollView.contentSize = filterOptionView.frame.size;
    [scrollView addSubview:filterOptionView];
    
    [self.view addSubview:scrollView];
}

- (void)back:(id)sender
{
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView setAnimationDuration:0.7];
    [UIView commitAnimations];

    [self.navigationController popViewControllerAnimated:NO];
}

- (void)saveFilter:(id)sender
{
    [delegate startSync:currentTeamId
              projectId:currentProjectId
               memberId:currentMemberId
                    tag:currentTag];
    
    [self back:nil];
}

- (void)selectFilter:(id)sender
{
    [teamTaskFilterLabel becomeFirstResponder];
}

@end
