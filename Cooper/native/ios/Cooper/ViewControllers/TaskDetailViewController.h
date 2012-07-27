//
//  TaskDetailViewController.h
//  Cooper
//
//  Created by Ping Li on 12-7-24.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "TaskDetailEditViewController.h"

@class TaskDao;
@class TaskIdxDao;
@class ChangeLogDao;

@interface TaskDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, CommentTextFieldDelegate>
{
    UITableView *detailView;
    
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
}

@property(nonatomic,assign) id<TaskViewDelegate> delegate;
@property (retain, nonatomic) Task *task;
@property (retain, nonatomic) DateLabel *dueDateLabel;
@property (retain, nonatomic) PriorityButton *priorityButton;
@property (retain, nonatomic) CustomButton *statusButton;
@property (retain, nonatomic) UILabel *subjectLabel;
@property (retain, nonatomic) UILabel *bodyLabel;
@property (retain, nonatomic) CommentTextField *commentTextField;
- (void) initContentView;

@end
