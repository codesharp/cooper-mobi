//
//  TaskDetailEditViewController.h
//  Cooper
//
//  Created by Ping Li on 12-7-26.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#include "Task.h"
#import "CustomButton.h"
#import "DateLabel.h"
#import "PriorityButton.h"
#import "CommentTextField.h"
#import "TaskViewDelegate.h"
#import "BaseViewController.h"

@class TaskDao;
@class TaskIdxDao;
@class ChangeLogDao;

@interface TaskDetailEditViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>
{
    UITableView *detailView;
     NSString *oldPriority;
    
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
}

@property (nonatomic,assign) id<TaskViewDelegate> delegate;
@property (retain, nonatomic) Task *task;
@property (retain, nonatomic) UITextField   *subjectTextField;
@property (retain, nonatomic) UITextView    *bodyTextView;
@property (assign, nonatomic) BOOL currentIsCompleted;
@property (retain, nonatomic) NSDate *currentDueDate;
@property (retain, nonatomic) DateLabel *dueDateLabel;
@property (retain, nonatomic) NSString *currentPriority;
@property (retain, nonatomic) PriorityButton *priorityButton;
@property (retain, nonatomic) CustomButton *statusButton;
@property (retain, nonatomic) NSString* currentTasklistId;

@end
