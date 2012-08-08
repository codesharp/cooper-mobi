//
//  MainViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "TaskViewController.h"
#import "LoginViewController.h"
#import "TasklistViewController.h"

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //初始化设置为YES
    _launching = YES;
    
    if (_launching == YES) 
    {
        _launching = NO;
        
        if ([[ConstantClass instance] isSaveUser]) 
        {
            [self loginExit];
        }
        else 
        {
            LoginViewController *viewController = [[LoginViewController alloc] init];
            viewController.delegate = self;
            BaseNavigationController *login_navController = [[[BaseNavigationController alloc] initWithRootViewController:viewController] autorelease];
            
            
            [self.navigationController presentModalViewController:login_navController animated:NO];
            [viewController release];
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
