//
//  CustomTabBarViewController.m
//  Cooper
//
//  Created by Ping Li on 12-7-25.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CustomTabBarController.h"


@implementation CustomTabBarItem

@synthesize customImage;

-(void)dealloc
{
	[super dealloc];
	customImage = nil;
	[customImage release];
}

-(UIImage *)selectedImage{
	return self.customImage;
}

-(UIImage *)unselectedImage{
    return self.customImage;
}

@end

@implementation CustomTabBarController

-(void)viewDidLoad{
    
}

@end


@implementation UIToolbar (CustomImage2)   
- (void)drawRect:(CGRect)rect {   
    UIImage *image = [UIImage imageNamed: TABBAR_BG_IMAGE];   
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];   
}   
@end
