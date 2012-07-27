//
//  CustomerTabBarController.m
//  Cooper
//
//  Created by Ping Li on 12-7-23.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "CustomerTabBarController.h"

@interface CustomerTabBarController ()

@end

@implementation CustomerTabBarController

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
	// Do any additional setup after loading the view.
    
//    CGRect frame = CGRectMake(0, 0, 320, 44);
//	UIView *v = [[UIView alloc] initWithFrame:frame];
//	UIColor *c = [[UIColor alloc] initWithRed:0.4 green:0.7 blue:0.3 alpha:1.0];
//    v.backgroundColor = c;
//    [c release];
//	[self.tabBar insertSubview:v atIndex:0];
//    [v release];
//	NSLog(@"view did load")

    
    UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_bg.png"]];
	//image.frame = CGRectOffset(image.frame, 0, 5);
	image.frame = CGRectMake(0, 0, 320,49);
	[self.tabBar insertSubview:image atIndex:0];
	[image release];
    
    NSLog(@"view did load");
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
