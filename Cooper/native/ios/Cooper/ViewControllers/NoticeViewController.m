//
//  NoticeViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-30.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "NoticeViewController.h"
#import "CustomButton.h"

@implementation NoticeViewController

@synthesize noticeTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"提醒设置", @"提醒设置");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    CustomButton *saveTaskBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(5,5,50,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
//    saveTaskBtn.layer.cornerRadius = 6.0f;
//    [saveTaskBtn.layer setMasksToBounds:YES];
//    [saveTaskBtn addTarget:self action:@selector(saveSetting:) forControlEvents:UIControlEventTouchUpInside];
//    [saveTaskBtn setTitle:@"确定" forState:UIControlStateNormal];
//    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithCustomView:saveTaskBtn] autorelease];
//    self.navigationItem.rightBarButtonItem = saveButton;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(goBack:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    
    self.noticeTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped] autorelease];
    self.noticeTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
    self.noticeTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.noticeTableView.dataSource = self;
    self.noticeTableView.delegate = self;
    [self.view addSubview:self.noticeTableView];
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

- (void)goBack:(id)sender
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)saveSetting:(id)sender
{
   [[ConstantClass instance] setIsLocalPush: localPushSwitch.on];    
    [ConstantClass saveIsLocalPushToCache];
    
    [self goBack:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LocalPushCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LocalPushCell"] autorelease];
                
                cell.textLabel.text = @"提醒";
                
                localPushSwitch = [[[UISwitch alloc]initWithFrame:CGRectMake(10, 10, 60, 30)] autorelease];
                [localPushSwitch addTarget:self action:@selector(localPushChanged:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = localPushSwitch;
            }
            
            if([[ConstantClass instance] isLocalPush])
            {
                [localPushSwitch setOn:YES];
            }
            else 
            {
                [localPushSwitch setOn:NO];
            }
        }
    }
    
    return cell;
}

- (void)localPushChanged:(id)sender
{
    [[ConstantClass instance] setIsLocalPush: localPushSwitch.on];
    [ConstantClass saveIsLocalPushToCache];
}

- (void)dealloc
{
    [localPushSwitch release];
    [super dealloc];
}

@end
