//
//  TaskTableViewCell.m
//  Cooper
//
//  Created by Ping Li on 12-7-23.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "TaskTableViewCell.h"

@implementation TaskTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
