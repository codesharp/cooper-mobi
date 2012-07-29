//
//  MainViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "MainViewController.h"
#import "CustomTabBarController.h"

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //初始化设置为YES
    _launching = YES;
    
    if (_launching == YES) 
    {
        _launching = NO;
        
        if ([[Constant instance] isSaveUser]) 
        {
            [self loginExit];
        }
        else 
        {
            LoginViewController *viewController = [[LoginViewController alloc] init];
            viewController.delegate = self;
            [self.navigationController presentModalViewController:viewController animated:NO];
            //[viewController release];
        }
    }
}

- (void)loginExit
{
    NSLog(@"退出登录");
    
    //打开任务列表
    TasklistViewController *tasklistController = [[[TasklistViewController alloc] init] autorelease];
                       
    BaseNavigationController *tasklist_navController = [[[BaseNavigationController alloc] initWithRootViewController:tasklistController] autorelease];
    
    [self.navigationController presentModalViewController:tasklist_navController animated:NO];
    
    //[tasklist_navController release];
    //[tasklistController release]; 
     
//    //个人任务
//    TaskViewController *taskViewController = [[[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil setTitle:@"个人任务" setImage:@"task.png"] autorelease];
//    
//    UINavigationController *task_navController = [[[UINavigationController alloc] initWithRootViewController:taskViewController] autorelease];
//    //HACK:版本兼容性问题
//    if (MODEL_VERSION >= 5.0) 
//    {
//        [task_navController.navigationBar setBackgroundImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE] forBarMetrics:UIBarMetricsDefault];
//    }
//    else 
//    {
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE]];
//        [imageView setFrame:CGRectMake(0, 0, 320, 44)];
//        [task_navController.navigationBar insertSubview:imageView atIndex:0];
//        [imageView release];
//    }
//    
//    //已完成
//    TaskViewController *completeTaskViewController = [[[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil setTitle:@"已完成" setImage:@"complete.png"] autorelease];
//    completeTaskViewController.filterStatus = @"1";
//    UINavigationController *complete_navController = [[[UINavigationController alloc] initWithRootViewController:completeTaskViewController] autorelease];
//    if (MODEL_VERSION >= 5.0) 
//    {
//        [complete_navController.navigationBar setBackgroundImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE] forBarMetrics:UIBarMetricsDefault];
//    }
//    else 
//    {
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE]];
//        [imageView setFrame:CGRectMake(0, 0, 320, 44)];
//        [complete_navController.navigationBar insertSubview:imageView atIndex:0];
//        [imageView release];
//    }
//    
//    //未完成
//    TaskViewController *incompleteTaskViewController = [[[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil setTitle:@"未完成" setImage:@"incomplete.png"] autorelease];
//    UINavigationController *incomplete_navViewController = [[[UINavigationController alloc] initWithRootViewController:incompleteTaskViewController] autorelease];
//    incompleteTaskViewController.filterStatus = @"0";
//    if (MODEL_VERSION >= 5.0) 
//    {
//        [incomplete_navViewController.navigationBar setBackgroundImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE] forBarMetrics:UIBarMetricsDefault];
//    }
//    else 
//    {
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE]];
//        [imageView setFrame:CGRectMake(0, 0, 320, 44)];
//        [incomplete_navViewController.navigationBar insertSubview:imageView atIndex:0];
//        [imageView release];
//    }
//    
//    //设置
//    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil setTitle:@"设置" setImage:@"setting.png"];
//    UINavigationController *setting_navViewController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
//    if (MODEL_VERSION >= 5.0) 
//    {
//        [setting_navViewController.navigationBar setBackgroundImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE] forBarMetrics:UIBarMetricsDefault];
//    }
//    else 
//    {
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE]];
//        [imageView setFrame:CGRectMake(0, 0, 320, 44)];
//        [setting_navViewController.navigationBar insertSubview:imageView atIndex:0];
//        [imageView release];
//    }
//        
//    UITabBarController *tabBarController = [[[UITabBarController alloc] init] autorelease];
//    if(MODEL_VERSION > 5.0)
//    {
//        [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:TABBAR_BG_IMAGE]];
//    }
//    else {
//        UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:TABBAR_BG_IMAGE]] autorelease];
//        [imageView setFrame:CGRectMake(0, 0, 320, 49)];
//        [tabBarController.tabBar insertSubview:imageView atIndex:0];
//    }
//    
//    tabBarController.viewControllers = [NSArray arrayWithObjects:task_navController, complete_navController, incomplete_navViewController, setting_navViewController, nil];
//
//    tabBarController.delegate = self;
//    
//    for (UIView *view in tabBarController.tabBar.subviews)
//    {      
//        if ([NSStringFromClass([view class]) isEqualToString:@"UITabBarButton"])
//        {
//            for (UIView *subview in view.subviews)
//            {                  
//                if ([subview isKindOfClass:[UILabel class]])
//                {
//                    UILabel *label = (UILabel *)subview;
//                    
//                    [label setTextColor:[UIColor whiteColor]];
//                }
//            }
//        }
//    } 
//    [self.navigationController presentModalViewController:tabBarController animated:NO];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
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
    
    if(tabBarController.selectedIndex == 0
       || tabBarController.selectedIndex == 1 
       || tabBarController.selectedIndex == 2)
    {
        UINavigationController* controller = (UINavigationController*)[tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex];

        if(controller == nil)
        {
            NSLog(@"controller:%@", [controller description]);
        }
        else {
            TaskViewController *tvController = (TaskViewController *)[controller.viewControllers objectAtIndex:0];
            if(tvController != nil)
                [tvController loadTaskData];
        }
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
