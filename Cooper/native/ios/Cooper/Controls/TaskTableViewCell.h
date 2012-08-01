//
//  TaskTableViewCell.h
//  Cooper
//
//  Created by Ping Li on 12-7-23.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "Task.h"
#import "TaskDao.h"
#import "TaskIdxDao.h"
#import "ChangeLogDao.h"

@protocol TaskTableViewCellDelegate <NSObject>

- (void) didSelectCell:(Task*)task;

@end

@interface TaskTableViewCell : UITableViewCell
{
    TaskDao *taskDao;
    ChangeLogDao *changeLogDao;
}

- (void) setTaskInfo:(Task*)task;
@property (nonatomic, retain) Task* task;

@property (nonatomic, retain) UILabel *subjectLabel;
@property (nonatomic, retain) UILabel *bodyLabel;
@property (nonatomic, retain) UILabel *dueDateLabel;
@property (nonatomic, retain) UIButton *statusButton;
@property (nonatomic, retain) UIButton *arrowButton;
@property (nonatomic, retain) UIView *leftView;
//@property (nonatomic, retain) UIView *rightView;

@property (nonatomic, assign) id<TaskTableViewCellDelegate> delegate;

@end
