//
//  TeamTaskViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-9-17.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TeamTaskViewController.h"
#import "CustomTabBarController.h"
#import "CustomToolbar.h"

@interface TeamTaskViewController ()

@end

@implementation TeamTaskViewController

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
    
    statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 374, 320, 44)];
    statusView.backgroundColor = [UIColor redColor];
    [self.view addSubview:statusView];
	
//    //底部条
//    CustomTabBarItem *tabBarItem = [[CustomTabBarItem alloc] init];
//    [tabBarItem setTitle:@""];
//    self.tabBarItem = tabBarItem;
//    [tabBarItem release];
    
//    CGRect frame = CGRectMake(0, 0, 320, 44);
//	UIView *v = [[UIView alloc] initWithFrame:frame];
//	UIColor *c = [[UIColor alloc] initWithRed:0.4 green:0.7 blue:0.3 alpha:1.0];
//    v.backgroundColor = c;
//    [c release];
//	[self.tabBar insertSubview:v atIndex:0];
//    [v release];
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
