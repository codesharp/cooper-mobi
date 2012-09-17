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
    
    statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 369, [Tools screenMaxWidth], 49)];
    statusView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:TABBAR_BG_IMAGE]];
    [self.view addSubview:statusView];
	
    
    NSString* word = @"Project 1 - Tag:native hybrid";
    CGSize size = [word sizeWithFont:[UIFont systemFontOfSize:12]];
    filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    filterLabel.text = word;
    filterLabel.backgroundColor = [UIColor redColor];
    [statusView addSubview:filterLabel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [filterLabel release];
    [statusView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
