//
//  MainViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    _launching = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (YES == _launching) {
        _launching = NO;
        //LoginViewController *viewController = [[LoginViewController alloc] init];
        //viewController.delegate = self;
        //[self.navigationController presentModalViewController:viewController animated:NO];
        
        [self loginExit];
    }

}

- (void)loginExit
{
    NSLog(@"login Exit");
    
    //个人任务
    TaskViewController *taskViewController1 = [[[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil setTitle:@"个人任务" setImage:@"first"] autorelease];
    UINavigationController *navTaskViewController1 = [[[UINavigationController alloc] initWithRootViewController:taskViewController1] autorelease];
//    navTaskViewController1.navigationBar.tintColor = [UIColor blueColor];
    navTaskViewController1.navigationBar.tintColor = APP_BACKGROUNDCOLOR;

    //已完成
    TaskViewController *taskViewController2 = [[[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil setTitle:@"已完成" setImage:@"first"] autorelease];
    UINavigationController *navTaskViewController2 = [[[UINavigationController alloc] initWithRootViewController:taskViewController2] autorelease];
    taskViewController2.filterStatus = @"1";
    navTaskViewController2.navigationBar.tintColor = APP_BACKGROUNDCOLOR;
    
    //未完成
    TaskViewController *taskViewController3 = [[[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil setTitle:@"未完成" setImage:@"first"] autorelease];
    UINavigationController *navTaskViewController3 = [[[UINavigationController alloc] initWithRootViewController:taskViewController3] autorelease];
    taskViewController3.filterStatus = @"0";
    navTaskViewController3.navigationBar.tintColor = APP_BACKGROUNDCOLOR;
    
    //设置
    SettingViewController *settingViewController = [[[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil] autorelease];
    UINavigationController *navTaskViewController4 = [[[UINavigationController alloc] initWithRootViewController:settingViewController] autorelease];
    navTaskViewController4.navigationBar.tintColor = APP_BACKGROUNDCOLOR;
    
    UITabBarController *tabBarController = [[[UITabBarController alloc] init] autorelease];
        tabBarController.viewControllers = [NSArray arrayWithObjects:navTaskViewController1, navTaskViewController2, navTaskViewController3, navTaskViewController4, nil];
    tabBarController.delegate = self;
    
    [self.navigationController presentModalViewController:tabBarController animated:NO];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
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
