//
//  BaseViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

@synthesize HUD;

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
    //初始化背景和尺寸
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:APP_BACKGROUNDIMAGE]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - HttpWebRequest回调相关

- (void)notProcessReturned:(NSMutableDictionary*)context
{
    [Tools close:HUD];
}
- (void)networkNotReachable
{
    [Tools msg:NOT_NETWORK_MESSAGE HUD:HUD];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求异常: %@", request.error.localizedDescription);
    [Tools msg:request.error.localizedDescription HUD:self.HUD];
}
- (void)addRequstToPool:(ASIHTTPRequest *)request
{
    NSLog(@"发送请求路径: %@", request.url);
}

@end
