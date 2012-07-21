//
//  TaskViewCell.h
//  Cooper
//
//  Created by sunleepy on 12-7-3.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@class TaskDao;
@class TaskIdxDao;
@class ChangeLogDao;

@interface TaskViewCell : UITableViewCell
{
    TaskDao *taskDao;
    ChangeLogDao *changeLogDao;
}

- (IBAction)setCompletedAction:(id)sender;
- (void)initCheck;

@property (retain, nonatomic) IBOutlet UILabel *textDueDate;
@property (retain, nonatomic) IBOutlet UIButton *completeBtn;
@property (nonatomic, retain) Task *task;
@end
