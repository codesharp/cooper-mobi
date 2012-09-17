//
//  TaskOptionViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-9-13.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskOptionViewController.h"

@implementation TaskOptionViewController

@synthesize tasklistViewController;
@synthesize teamViewController;

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
    
    self.title = @"类型选择";
    
    taskOptionView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    taskOptionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
    taskOptionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    taskOptionView.dataSource = self;
    taskOptionView.delegate = self;
    [self.view addSubview:taskOptionView];
    
    //设置右选项卡中的按钮
    settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(0, 10, 27, 27);
    [settingBtn setBackgroundImage:[UIImage imageNamed:SETTING_IMAGE] forState:UIControlStateNormal];
    [settingBtn addTarget: self action: @selector(settingAction:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *settingButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    self.navigationItem.rightBarButtonItem = settingButtonItem;
    [settingButtonItem release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [taskOptionView release];
    [tasklistViewController release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
        selectedView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
        //设置选中后cell的背景颜色
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = selectedView;
        [selectedView release];
    }
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"个人任务";
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"团队任务";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            //打开个人任务列表
            if (tasklistViewController == nil)
            {
                tasklistViewController = [[TasklistViewController alloc] init];
            }        
            [Tools layerTransition:self.navigationController.view from:@"right"];
            [self.navigationController pushViewController:tasklistViewController animated:NO];
        }
        else if(indexPath.row == 1)
        {
            //打开团队任务列表
            if(teamViewController == nil)
            {
                teamViewController = [[TeamViewController alloc] init];
            }
            [Tools layerTransition:self.navigationController.view from:@"right"];
            [self.navigationController pushViewController:teamViewController animated:NO];
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
