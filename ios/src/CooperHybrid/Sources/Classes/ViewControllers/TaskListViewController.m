//
//  TaskListViewController.m
//  CooperGap
//
//  Created by sunleepy on 12-7-18.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskListViewController.h"

@interface TaskListViewController ()

@end

@implementation TaskListViewController

- (id)initWithTitle:(NSString*)title setImage:(NSString*)imageName
{
    self = [super init];
    if(self) {
        self.title = NSLocalizedString(title, title);
        self.tabBarItem.image = [UIImage imageNamed:imageName];
        
        CGRect viewBounds = CGRectMake(0, 0, 0, 0);

        self.view.frame = viewBounds;
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    self.wwwFolderName = @"Hybrid";
    self.startPage = @"index.htm";
    
    [super viewDidLoad];
    
    //设置右选项卡中的按钮
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)] autorelease];    
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)insertNewObject:(id)sender
{   
    //self.wwwFolderName = @"www";
    //self.invokeString = @"detail.html";
    //[self loadView];
    //[self reloadInputViews];
    //self.useSplashScreen = YES;
    self.wwwFolderName = @"www";
    self.startPage = @"detail.html";
    self.invokeString = @"detail.html";

    
    [self.webView stringByEvaluatingJavaScriptFromString:@"test('done')"];
}

/* Comment out the block below to over-ride */
/*
 - (CDVCordovaView*) newCordovaViewWithFrame:(CGRect)bounds
 {
 return[super newCordovaViewWithFrame:bounds];
 }
 */

/* Comment out the block below to over-ride */
/*
 #pragma CDVCommandDelegate implementation
 
 - (id) getCommandInstance:(NSString*)className
 {
 return [super getCommandInstance:className];
 }
 
 - (BOOL) execute:(CDVInvokedUrlCommand*)command
 {
 return [super execute:command];
 }
 
 - (NSString*) pathForResource:(NSString*)resourcepath;
 {
 return [super pathForResource:resourcepath];
 }
 
 - (void) registerPlugin:(CDVPlugin*)plugin withClassName:(NSString*)className
 {
 return [super registerPlugin:plugin withClassName:className];
 }
 */

#pragma UIWebDelegate implementation

- (void) webViewDidFinishLoad:(UIWebView*) theWebView 
{
    // only valid if ___PROJECTNAME__-Info.plist specifies a protocol to handle
    if (self.invokeString)
    {
        // this is passed before the deviceready event is fired, so you can access it in js when you receive deviceready
        NSString* jsString = [NSString stringWithFormat:@"var invokeString = \"%@\";", self.invokeString];
        [theWebView stringByEvaluatingJavaScriptFromString:jsString]; 
    }
    
    if([[ConstantClass instance] isGuestUser])
    {
        [self.webView stringByEvaluatingJavaScriptFromString:@"showStartPage(1);"];
    }
    
    // Black base color for background matches the native apps
    theWebView.backgroundColor = [UIColor blackColor];
    
	return [super webViewDidFinishLoad:theWebView];
}

/* Comment out the block below to over-ride */
/*
 
 - (void) webViewDidStartLoad:(UIWebView*)theWebView 
 {
 return [super webViewDidStartLoad:theWebView];
 }
 
 - (void) webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error 
 {
 return [super webView:theWebView didFailLoadWithError:error];
 }
 
 - (BOOL) webView:(UIWebView*)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
 {
 return [super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType];
 }
 */

@end
