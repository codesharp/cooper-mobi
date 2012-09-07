//
//  SettingViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-12.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "SettingViewController.h"
#import "PathViewController.h"
#import "AccountViewController.h"
#import "NoticeViewController.h"
#import "CustomTabBarController.h"
#import "UIImage+Scale.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
             setTitle:(NSString *)title 
             setImage:(NSString*)imageName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = APP_TITLE;
        CustomTabBarItem *tabBarItem = [[CustomTabBarItem alloc] init];
        [tabBarItem setTitle:title];
        [tabBarItem setCustomImage:[UIImage imageNamed:imageName]];
        self.tabBarItem = tabBarItem;    
        [tabBarItem release];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backButtonItem;
//    [backButtonItem release];
    [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
    self.tabBarController.title = @"系统设置";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AccountCell"] autorelease];
                
                cell.textLabel.text = @"帐号设置";
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.editingAccessoryType = UITableViewCellAccessoryNone;
                
                UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];   
                selectedView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
                cell.backgroundColor = [UIColor whiteColor];
                //设置选中后cell的背景颜色
                cell.selectedBackgroundView = selectedView;
                [selectedView release];
            }
        }
//        else if(indexPath.row == 2)
//        {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
//            if(!cell)
//            {
//                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"NoticeCell"] autorelease];
//                
//                cell.textLabel.text = @"提醒设置";
//                
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                cell.editingAccessoryType = UITableViewCellAccessoryNone;
//                
//                UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
//                selectedView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
//                //设置选中后cell的背景颜色
//                cell.selectedBackgroundView = selectedView;
//                [selectedView release];
//            }
//        }
//        else if(indexPath.row == 3)
//        {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"ApplicationCell"];
//            if(!cell)
//            {
//                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"applicationCell"] autorelease];
//                
//                cell.textLabel.text = @"版本检测";
//                cell.detailTextLabel.text = @"v1.0";
//                
//                //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                //cell.editingAccessoryType = UITableViewCellAccessoryNone;
//            }
//        }
    }
                                                                                  
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            AccountViewController *accountViewController = [[[AccountViewController alloc] init] autorelease]; 
            
            CATransition* transition = [CATransition animation];
            transition.duration = 0.3;
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            
            [self.navigationController pushViewController:accountViewController animated:NO];
        }
//        else if(indexPath.row == 2)
//        {
//            NoticeViewController *noticeViewController = [[[NoticeViewController alloc] init] autorelease];
//            [self.navigationController pushViewController:noticeViewController animated:NO];
//        }
    }
}

-(void)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

@end
