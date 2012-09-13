//
//  TaskOptionViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-9-13.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskOptionViewController.h"

@interface TaskOptionViewController ()

@end

@implementation TaskOptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    taskOptionView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    taskOptionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
    taskOptionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    taskOptionView.dataSource = self;
    taskOptionView.delegate = self;
    [self.view addSubview:taskOptionView];
    
    //设置右选项卡中的按钮
    settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(0, 10, 27, 27);
    [settingBtn setBackgroundImage:[UIImage imageNamed:SETTING_IMAGE] forState:UIControlStateNormal];
    [settingBtn addTarget: self action: @selector(settingAction:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *settingButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    self.navigationItem.rightBarButtonItem = settingButtonItem;
    [settingButtonItem release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [taskOptionView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
