//
//  MainViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "MainViewController.h"
#import "TaskViewController.h"
#import "TasklistViewController.h"

@implementation MainViewController

@synthesize tasklistNavController;
@synthesize loginViewNavController;
@synthesize taskOptionNavController;

# pragma mark - UI相关

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[ConstantClass instance] loginType] isEqualToString:@"anonymous"]
        || [[[ConstantClass instance] loginType] isEqualToString:@"normal"]
        || [[[ConstantClass instance] loginType] isEqualToString:@"google"])
    {
        //跳过登录
        [self loginFinish];
    }
    else 
    {
        if(loginViewNavController == nil)
        {
            //登录
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            loginViewController.delegate = self;
            loginViewNavController = [[BaseNavigationController alloc] initWithRootViewController:loginViewController];
            [loginViewController release];
        }
        [self.navigationController presentModalViewController:loginViewNavController animated:NO];
    }
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
                    label.textColor = [UIColor whiteColor];
                }
            }
        }
    } 
}

- (void)viewDidUnload
{
    loginViewNavController = nil;
    tasklistNavController = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    RELEASE(loginViewNavController);
    RELEASE(tasklistNavController);
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - 相关动作事件

- (void)loginFinish
{
    NSLog(@"登录完毕");
    
    //打开任务列表
    if(tasklistNavController == nil)
    {
        TasklistViewController *tasklistViewController = [[TasklistViewController alloc] init];
        tasklistNavController = [[BaseNavigationController alloc] initWithRootViewController:tasklistViewController];
        [tasklistViewController release];
    }
    [self.navigationController presentModalViewController:tasklistNavController animated:NO];
}

- (void)googleLoginFinish
{
    
}

@end
