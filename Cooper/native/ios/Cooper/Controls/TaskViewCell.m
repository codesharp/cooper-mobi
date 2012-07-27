//
//  TaskViewCell.m
//  Cooper
//
//  Created by sunleepy on 12-7-3.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskViewCell.h"

@implementation TaskViewCell
@synthesize textDueDate;
@synthesize completeBtn;
@synthesize task;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = 
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [textDueDate release];
    [completeBtn release];
    [taskDao release];
    [changeLogDao release];
    [super dealloc];
}

- (IBAction)setCompletedAction:(id)sender {
    if(task.status == [NSNumber numberWithInt:1])
    {
        UIButton *button = (UIButton*)sender;
        [button setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
        task.status = [NSNumber numberWithInt:0];
    }
    else {
        UIButton *button = (UIButton*)sender;
        [button setBackgroundImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
        task.status = [NSNumber numberWithInt:1];  
    }
    
    [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] dataid:task.id name:@"iscompleted" value:task.status == [NSNumber numberWithInt:1] ? @"true" : @"false"];

    
    [taskDao commitData];
}
- (void)initCheck
{
    taskDao = [[TaskDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
    
    if(task.status == [NSNumber numberWithInt:1])
    {
        [completeBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
    }
    else {
        [completeBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
    }
}
@end
