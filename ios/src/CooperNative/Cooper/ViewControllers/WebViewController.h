//
//  WebViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-9-7.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomButton.h"

@interface WebViewController : BaseViewController
{
	UIWebView *_webView;
	NSURL *_url;
}
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSURL *url;

- (void)done:(id)sender;

@end
