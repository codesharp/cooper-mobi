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
#import "TasklistViewController.h"

@implementation MainViewController

@synthesize tasklistViewController;
@synthesize loginViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[ConstantClass instance] isGuestUser]) 
    {
        //游客登录
        [self loginFinish];
    }
    else 
    {
        //普通登录
        loginViewController = [[LoginViewController alloc] init];
        loginViewController.delegate = self;
        BaseNavigationController *login_navController = [[BaseNavigationController alloc] initWithRootViewController:loginViewController];
 
        [self.navigationController presentModalViewController:login_navController animated:NO];
        [login_navController release];
    }
}

- (void)loginFinish
{
    NSLog(@"登录完毕");
    
    //打开任务列表
    tasklistViewController = [[TasklistViewController alloc] init];
                       
    BaseNavigationController *tasklist_navController = [[BaseNavigationController alloc] initWithRootViewController:tasklistViewController];
    
    [self.navigationController presentModalViewController:tasklist_navController animated:NO];  
    [tasklist_navController release];
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
    
//    if(tabBarController.selectedIndex == 0
//       || tabBarController.selectedIndex == 1 
//       || tabBarController.selectedIndex == 2)
//    {
//        UINavigationController* controller = (UINavigationController*)[tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex];
//
//        if(controller == nil)
//        {
//            NSLog(@"controller:%@", [controller description]);
//        }
//        else {
//            TaskViewController *tvController = (TaskViewController *)[controller.viewControllers objectAtIndex:0];
//            if(tvController != nil)
//                [tvController loadTaskData];
//        }
//    }
}
- (void)viewDidUnload
{
    loginViewController = nil;
    tasklistViewController = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    RELEASE(loginViewController);
    RELEASE(tasklistViewController);
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
