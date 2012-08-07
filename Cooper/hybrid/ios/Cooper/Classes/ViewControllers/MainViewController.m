//
//  MainViewController.m
//  CooperGap
//
//  Created by 磊 李 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "TaskListViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize taskListViewController;

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
    
    NSString* invokeString = @"";
	
    //个人任务
    self.taskListViewController = [[[TaskListViewController alloc] initWithTitle:@"个人任务" setImage:@"first"] autorelease];
    CGRect viewBounds = CGRectMake(0, 0, 0, 0);
    //CGRect viewBounds = [[UIScreen mainScreen] applicationFrame];
    //taskListViewController.useSplashScreen = YES;
    //self.taskListViewController.invokeString = invokeString;
    self.taskListViewController.view.frame = viewBounds;
    
    // check whether the current orientation is supported: if it is, keep it, rather than forcing a rotation
    BOOL forceStartupRotation = YES;
    UIDeviceOrientation curDevOrientation = [[UIDevice currentDevice] orientation];
    
    if (UIDeviceOrientationUnknown == curDevOrientation) {
        // UIDevice isn't firing orientation notifications yet… go look at the status bar
        curDevOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    }
    
    if (UIDeviceOrientationIsValidInterfaceOrientation(curDevOrientation)) {
        for (NSNumber *orient in self.taskListViewController.supportedOrientations) {
            if ([orient intValue] == curDevOrientation) {
                forceStartupRotation = NO;
                break;
            }
        }
    } 
    
    if (forceStartupRotation) {
        NSLog(@"supportedOrientations: %@", self.taskListViewController.supportedOrientations);
        // The first item in the supportedOrientations array is the start orientation (guaranteed to be at least Portrait)
        UIInterfaceOrientation newOrient = [[self.taskListViewController.supportedOrientations objectAtIndex:0] intValue];
        NSLog(@"AppDelegate forcing status bar to: %d from: %d", newOrient, curDevOrientation);
        [[UIApplication sharedApplication] setStatusBarOrientation:newOrient];
    }
    
//    UINavigationController *navTaskViewController1 = [[[UINavigationController alloc] initWithRootViewController:self.taskListViewController] autorelease];
//        navTaskViewController1.navigationBar.tintColor = [UIColor blueColor];
//    navTaskViewController1.navigationBar.tintColor = APP_BACKGROUNDCOLOR;
    
    //UITabBarController *tabBarController = [[[UITabBarController alloc] init] autorelease];
    //tabBarController.viewControllers = [NSArray arrayWithObjects:self.taskListViewController, nil];
    //tabBarController.delegate = self;
    
    [self.navigationController presentModalViewController:taskListViewController animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
