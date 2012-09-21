//
//  TaskOptionViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-9-13.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskOptionViewController.h"
#import "SettingViewController.h"
#import "TaskController.h"

@implementation TaskOptionViewController

@synthesize tasklistViewController;
@synthesize teamViewController;
@synthesize setting_navViewController;
@synthesize teamTaskViewController;

@synthesize tasklists;
@synthesize teams;

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
    
    tasklistDao = [[TasklistDao alloc] init];
    teamDao = [[TeamDao alloc] init];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    NSInteger rTasklistIdCount = [[[ConstantClass instance] recentlyIds] count];
    NSInteger rTeamIdCount = [[[ConstantClass instance] recentlyTeamIds] count];
    if(rTasklistIdCount + rTeamIdCount > 0)
    {
        tasklists = [tasklistDao getAllTasklist];
        teams = [teamDao getTeams];
    }
    if(tasklists == nil)
    {
        tasklists = [NSMutableArray array];
    }
    if(teams == nil)
    {
        teams = [NSMutableArray array];
    }
    
    [taskOptionView reloadData];
}

- (void)dealloc
{
    [taskOptionView release];
    [settingBtn release];
    [tasklistViewController release];
    [setting_navViewController release];
    [teamViewController release];
    [tasklistDao release];
    [teamDao release];
//    [tasklists release];
//    [teams release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger rTasklistIdCount = [[[ConstantClass instance] recentlyIds] count];
    NSInteger rTeamIdCount = [[[ConstantClass instance] recentlyTeamIds] count];
    if(rTasklistIdCount + rTeamIdCount > 0)
        return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rTasklistIdCount = [[[ConstantClass instance] recentlyIds] count];
    NSInteger rTeamIdCount = [[[ConstantClass instance] recentlyTeamIds] count];
    if(rTasklistIdCount + rTeamIdCount > 0)
    {
        if(section == 0)
        {
            return rTasklistIdCount + rTeamIdCount;
        }
        else if(section == 1)
            return 2;
        else
            return 0;
    }
    return 2;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSInteger rTasklistIdCount = [[[ConstantClass instance] recentlyIds] count];
    NSInteger rTeamIdCount = [[[ConstantClass instance] recentlyTeamIds] count];
    if(rTasklistIdCount + rTeamIdCount > 0)
    {
        if(section == 0)
        {
            return @"最近查看";
        }
        else
        {
            return @"";
        }
    }
    else
    {
        return @"";
    }
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
    
    NSInteger rTasklistIdCount = [[[ConstantClass instance] recentlyIds] count];
    NSInteger rTeamIdCount = [[[ConstantClass instance] recentlyTeamIds] count];
    if(rTasklistIdCount + rTeamIdCount > 0)
    {
        if(indexPath.section == 0)
        {
            tasklists = [tasklistDao getAllTasklist];
            teams = [teamDao getTeams];
            
            NSMutableArray *recentlyIds = (NSMutableArray*)[[ConstantClass instance] recentlyIds];
            if(indexPath.row < recentlyIds.count)
            {
                NSString* tasklistId = [recentlyIds objectAtIndex:indexPath.row];
                for(int i = 0; i < tasklists.count; i++)
                {
                    Tasklist* t = (Tasklist*)[tasklists objectAtIndex:i];
                    if([tasklistId isEqualToString: t.id])
                    {
                        cell.textLabel.text = t.name;
                        break;
                    }
                }
            }
            else
            {
                NSMutableArray *recentlyTeamIds = (NSMutableArray*)[[ConstantClass instance] recentlyTeamIds];
                
                NSString* teamId = [recentlyTeamIds objectAtIndex:indexPath.row - recentlyIds.count];
                for(int i = 0; i < teams.count; i++)
                {
                    Team* t = (Team*)[teams objectAtIndex:i];
                    if([teamId isEqualToString: t.id])
                    {
                        cell.textLabel.text = t.name;
                        break;
                    }
                }
            }
        }
        else
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
    }
    else
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
    
//    if(indexPath.section == 0)
//    {
//        if(indexPath.row == 0)
//        {
//            cell.textLabel.text = @"个人任务";
//        }
//        else if(indexPath.row == 1)
//        {
//            cell.textLabel.text = @"团队任务";
//        }
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rTasklistIdCount = [[[ConstantClass instance] recentlyIds] count];
    NSInteger rTeamIdCount = [[[ConstantClass instance] recentlyTeamIds] count];
    if(rTasklistIdCount + rTeamIdCount > 0)
    {
        if(indexPath.section == 0)
        {
            tasklists = [tasklistDao getAllTasklist];
            teams = [teamDao getTeams];
            
            NSMutableArray *recentlyIds = (NSMutableArray*)[[ConstantClass instance] recentlyIds];
            if(indexPath.row < recentlyIds.count)
            {
                NSString* tasklistId = [recentlyIds objectAtIndex:indexPath.row];
                for(int i = 0; i < tasklists.count; i++)
                {
                    Tasklist* t = (Tasklist*)[tasklists objectAtIndex:i];
                    if([tasklistId isEqualToString: t.id])
                    {
                        //切换到任务界面
                        
                        //个人任务
                        TaskController *taskViewController = [[[TaskController alloc] initWithNibName:@"TaskController"
                                                                                               bundle:nil
                                                                                             setTitle:@"个人任务"
                                                                                             setImage:@"task.png"] autorelease];
                        taskViewController.currentTasklistId = tasklistId;
                        
                        //已完成
                        TaskController *completeTaskViewController = [[[TaskController alloc] initWithNibName:@"TaskController"
                                                                                                       bundle:nil
                                                                                                     setTitle:@"已完成"
                                                                                                     setImage:@"complete.png"] autorelease];
                        completeTaskViewController.filterStatus = @"1";         //完成状态设置为1
                        completeTaskViewController.currentTasklistId = tasklistId;
                        
                        //未完成
                        TaskController *incompleteTaskViewController = [[[TaskController alloc] initWithNibName:@"TaskController"
                                                                                                         bundle:nil
                                                                                                       setTitle:@"未完成"
                                                                                                       setImage:@"incomplete.png"] autorelease];
                        incompleteTaskViewController.filterStatus = @"0";       //未完成状态设置为0
                        incompleteTaskViewController.currentTasklistId = tasklistId;
                        
                        //设置
                        SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController"
                                                                                                               bundle:nil
                                                                                                             setTitle:@"设置"
                                                                                                             setImage:SETTING_IMAGE];
                        
                        UITabBarController *tabBarController = [[[UITabBarController alloc] init] autorelease];
                        
                        [tabBarController.navigationItem setHidesBackButton:YES];
                        if(MODEL_VERSION > 5.0)
                        {
                            [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:TABBAR_BG_IMAGE]];
                            [tabBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selectedbg.png"]];
                        }
                        else {
                            UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:TABBAR_BG_IMAGE]] autorelease];
                            [imageView setFrame:CGRectMake(0, 0, [Tools screenMaxWidth], 49)];
                            [tabBarController.tabBar insertSubview:imageView atIndex:0];
                        }
                        
                        tabBarController.viewControllers = [NSArray arrayWithObjects:taskViewController, completeTaskViewController, incompleteTaskViewController, settingViewController, nil];
                        tabBarController.delegate = self;
                        
                        for (UIView *view in tabBarController.tabBar.subviews)
                        {      
                            if ([NSStringFromClass([view class]) isEqualToString:@"UITabBarButton"])
                            {
                                for (UIView *subview in view.subviews)
                                {                  
                                    if ([subview isKindOfClass:[UILabel class]])
                                    {
                                        UILabel *label = (UILabel *)subview;
                                        
                                        [label setTextColor:[UIColor whiteColor]];
                                    }
                                }
                            }
                        } 
                        
                        [Tools layerTransition:self.navigationController.view from:@"right"];
                        [self.navigationController pushViewController:tabBarController animated:NO];
                        
                        break;
                    }
                }
            }
            else
            {
                NSMutableArray *recentlyTeamIds = (NSMutableArray*)[[ConstantClass instance] recentlyTeamIds];
                
                NSString* teamId = [recentlyTeamIds objectAtIndex:indexPath.row - recentlyIds.count];
                for(int i = 0; i < teams.count; i++)
                {
                    Team* t = (Team*)[teams objectAtIndex:i];
                    if([teamId isEqualToString: t.id])
                    {
                        //打开团队任务列表
                        if (teamTaskViewController == nil)
                        {
                            teamTaskViewController = [[TeamTaskViewController alloc] init];
                        }
                        
                        teamTaskViewController.currentTeamId = teamId;
                        teamTaskViewController.currentProjectId = nil;
                        teamTaskViewController.currentMemberId = nil;
                        teamTaskViewController.currentTag = nil;
                        teamTaskViewController.needSync = YES;
                        
                        [Tools layerTransition:self.navigationController.view from:@"right"];
                        [self.navigationController pushViewController:teamTaskViewController animated:NO];
                        
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                        
                        break;
                    }
                }
            }
        }
        else if(indexPath.section == 1)
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
    else
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

- (void)settingAction:(id)sender
{
    if(setting_navViewController == nil)
    {
        //设置
        SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil setTitle:@"设置" setImage:SETTING_IMAGE];
        
        setting_navViewController = [[BaseNavigationController alloc] initWithRootViewController:settingViewController];
        
        //后退按钮
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBack.frame = CGRectMake(5, 5, 25, 25);
        [btnBack setBackgroundImage:[UIImage imageNamed:BACK_IMAGE] forState:UIControlStateNormal];
        [btnBack addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
        settingViewController.navigationItem.leftBarButtonItem = backButtonItem;
        [self.navigationController presentModalViewController:setting_navViewController animated:YES];
        
        [backButtonItem release];
        [settingViewController release];
    }
    else
    {
        [self.navigationController presentModalViewController:setting_navViewController animated:YES];
    }
}

- (void)goBack:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
