//
//  TaskTableViewCell.m
//  Cooper
//
//  Created by Ping Li on 12-7-23.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskTableViewCell.h"

#define PADDING         5.0f
#define CONTENT_WIDTH   200.0f
#define MAX_HEIGHT      10000.0f
#define BODY_MAX_LINE   3

@implementation TaskTableViewCell

@synthesize subjectLabel;
@synthesize bodyLabel;
@synthesize dueDateLabel;
@synthesize assigneeNameLabel;
@synthesize statusButton;
@synthesize arrowButton;
@synthesize leftView;
//@synthesize rightView;
@synthesize task;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContentView];
        // Initialization code
    }
    return self;
}

- (void)initContentView
{
    subjectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [subjectLabel setLineBreakMode:UILineBreakModeWordWrap];
    [subjectLabel setFont:[UIFont boldSystemFontOfSize:16]];
    
    bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [bodyLabel setLineBreakMode:UILineBreakModeWordWrap];
    [bodyLabel setFont:[UIFont systemFontOfSize:14]];
    [bodyLabel setTextColor:[UIColor lightGrayColor]];
    
    dueDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [dueDateLabel setLineBreakMode:UILineBreakModeWordWrap];
    [dueDateLabel setFont:[UIFont systemFontOfSize:14]];
    [dueDateLabel setTextColor:APP_BACKGROUNDCOLOR];
    
    assigneeNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    assigneeNameLabel.font = [UIFont systemFontOfSize:12];
    assigneeNameLabel.textColor = APP_BACKGROUNDCOLOR;
    [self.contentView addSubview:assigneeNameLabel];
    
    [self.contentView addSubview:subjectLabel];
    [self.contentView addSubview:bodyLabel];
    [self.contentView addSubview:dueDateLabel];
    
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    
    statusButton = [[UIButton alloc] initWithFrame:CGRectMake(10, PADDING, 28, 17)];
    UIImage* image = [UIImage imageNamed:@"incomplete-small.png"];
    [statusButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.leftView addSubview:statusButton];
    
    self.leftView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setCompletedAction:)];
    tapped.numberOfTapsRequired = 1;
    [self.leftView addGestureRecognizer:tapped];   
    [tapped release];
    [self.contentView addSubview:self.leftView];
    
//    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(290, 0, 40, 30)];
//    arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 11,14)];
//    UIImage* image2 = [UIImage imageNamed:@"arowright.png"];
//    [arrowButton setBackgroundImage:image2 forState:UIControlStateNormal];
//    self.rightView.userInteractionEnabled = YES;
//
//    [self.rightView addSubview:arrowButton];
//    
//    
//    UITapGestureRecognizer *tapped2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoTaskDetail:)];
//    tapped2.numberOfTapsRequired = 1;
//    [self.rightView addGestureRecognizer:tapped2];   
//    [tapped2 release];
//    [self.contentView addSubview:self.rightView];
}

- (void)gotoTaskDetail:(id)sender
{ 
    [delegate didSelectCell:self.task];
}

- (void)setCompletedAction:(id)sender
{
    if(task.editable == [NSNumber numberWithInt:0])
    {
        return;
    }
    if([[task.status stringValue] isEqualToString:@"1"])
    {
        UIButton *button = statusButton;
        [button setBackgroundImage:[UIImage imageNamed:@"incomplete-small.png"] forState:UIControlStateNormal];
        task.status = [NSNumber numberWithInt:0];
    }
    else {
        UIButton *button = statusButton;
        [button setBackgroundImage:[UIImage imageNamed:@"complete-small.png"] forState:UIControlStateNormal];
        task.status = [NSNumber numberWithInt:1];  
    }
    
    [changeLogDao insertChangeLog:[NSNumber numberWithInt:0] 
                           dataid:task.id 
                             name:@"iscompleted" 
                            value:task.status == [NSNumber numberWithInt:1] ? @"true" : @"false" 
                       tasklistId:task.tasklistId];
       
    [taskDao commitData];
}

- (void)setTaskInfo:(Task *)taskInfo
{
    self.task = taskInfo;
    taskDao = [[TaskDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
    teamMemberDao = [[TeamMemberDao alloc] init];
    
    if([[task.status stringValue] isEqualToString:@"1"])
    {
        [statusButton setBackgroundImage:[UIImage imageNamed:@"complete-small.png"] forState:UIControlStateNormal];
    }
    else {
        [statusButton setBackgroundImage:[UIImage imageNamed:@"incomplete-small.png"] forState:UIControlStateNormal];
    }
    
    subjectLabel.text = task.subject; 
  
    CGSize subjectLabelSize = [subjectLabel.text sizeWithFont:subjectLabel.font 
                                    constrainedToSize:CGSizeMake(CONTENT_WIDTH + [Tools screenMaxWidth] - 320, MAX_HEIGHT)
                                        lineBreakMode:UILineBreakModeWordWrap];
        
    CGFloat subjectLabelHeight = subjectLabelSize.height;
  
    int subjectlines = subjectLabelHeight / 16;
    [subjectLabel setFrame:CGRectMake(50, PADDING, CONTENT_WIDTH + [Tools screenMaxWidth] - 320, subjectLabelHeight)];
    [subjectLabel setNumberOfLines:subjectlines];
    
    bodyLabel.text = task.body; 
    
    CGSize bodyLabelSize = [bodyLabel.text sizeWithFont:bodyLabel.font 
                                            constrainedToSize:CGSizeMake(CONTENT_WIDTH + [Tools screenMaxWidth] - 320, MAX_HEIGHT) 
                                                lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat bodyLabelHeight = bodyLabelSize.height;
    
    int bodylines = bodyLabelHeight / 16;
    
    if(bodylines > 3)
    {
        bodylines = 3;
    }
    [bodyLabel setFrame:CGRectMake(50, PADDING + subjectLabelHeight, CONTENT_WIDTH + [Tools screenMaxWidth] - 320, bodylines * 16)];
    [bodyLabel setNumberOfLines:bodylines];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M-dd"];
    if(task.dueDate != nil)
    {
        dueDateLabel.text = [formatter stringFromDate:task.dueDate];
        [dueDateLabel setFrame:CGRectMake(260  + [Tools screenMaxWidth] - 320, PADDING, 80, 20)];
    }
    
    CGFloat totalHeight;
    
    if(subjectLabelHeight == 0 && bodylines * 16 == 0)
        totalHeight = 50;
    else
        totalHeight = subjectLabelHeight + bodylines * 16 ;
    
    if(self.task.assigneeId != nil)
    {
        TeamMember *teamMember = [teamMemberDao getTeamMemberByTeamId:self.task.teamId
                                                           assigneeId:self.task.assigneeId];
        if(teamMember != nil)
        {
            assigneeNameLabel.text = teamMember.name;
            assigneeNameLabel.frame = CGRectMake(50, totalHeight, [Tools screenMaxWidth], 30);
            
            NSLog(@"TeamMember: %@", teamMember.name);
        }
        
        totalHeight += 30;
    }
    if(totalHeight < 50)
        totalHeight = 50;
    [self setFrame:CGRectMake(0, 0, CONTENT_WIDTH + [Tools screenMaxWidth] - 320, totalHeight)];
    [leftView setFrame:CGRectMake(0, 0, 40, totalHeight)];

//    CGRect rightRect = rightView.frame;
//    rightRect.size.height = totalHeight;
//    [rightView setFrame:rightRect];
//    
//    CGRect arrayRect = arrowButton.frame;
//    arrayRect.origin.y = (totalHeight - 14) / 2.0;
//    [arrowButton setFrame:arrayRect];
}

- (void)dealloc
{
    [super dealloc];
    [subjectLabel release];
    [bodyLabel release];
    [dueDateLabel release];
    [assigneeNameLabel release];
    [leftView release];
    //[rightView release];
    [statusButton release];
    [changeLogDao release];
    [taskDao release];
    [teamMemberDao release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
