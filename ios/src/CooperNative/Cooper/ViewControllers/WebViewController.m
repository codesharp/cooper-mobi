//
//  WebViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-9-7.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webView = _webView;
@synthesize url = _url;

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
	
    CustomButton *saveTaskBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(5,5,70,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
    saveTaskBtn.layer.cornerRadius = 6.0f;
    [saveTaskBtn.layer setMasksToBounds:YES];
    [saveTaskBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [saveTaskBtn setTitle:@"退出" forState:UIControlStateNormal];
    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithCustomView:saveTaskBtn] autorelease];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
    if (self.url)
	{
		[self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    self.url = nil;
	self.webView = nil;
    [super dealloc];
}

- (void)setUrl:(NSURL *)url
{
	[_url release];
	_url = [url retain];
	
	[self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

- (void)done:(id)sender
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end
