//
//  CustomToolbar.m
//  Cooper
//
//  Created by Ping Li on 12-7-25.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "CustomToolbar.h"

@implementation CustomToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect bounds=[self bounds];
    UIImage *image = [UIImage imageNamed:NAVIGATIONBAR_BG_IMAGE];   
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [image drawInRect:bounds];
}

@end
