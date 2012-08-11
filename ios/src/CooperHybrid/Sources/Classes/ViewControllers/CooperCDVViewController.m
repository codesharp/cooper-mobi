//
//  CooperCDVViewController.m
//  Cooper
//
//  Created by sunleepy on 12-8-7.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CooperCDVViewController.h"

@interface CooperCDVViewController ()

@end

@implementation CooperCDVViewController

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
