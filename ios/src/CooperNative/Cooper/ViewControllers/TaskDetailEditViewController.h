//
//  TaskDetailEditViewController.h
//  Cooper
//
//  Created by Ping Li on 12-7-26.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CooperCore/Task.h"
#import "CustomButton.h"
#import "DateLabel.h"
#import "PriorityButton.h"
#import "CommentTextField.h"
#import "TaskViewDelegate.h"
#import "BaseViewController.h"
#import "BodyTextView.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/TaskIdxDao.h"
#import "CooperRepository/ChangeLogDao.h"

@interface TaskDetailEditViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,DateLabelDelegate,PriorityButtonDelegate>
{
    UITableView *detailView;
     NSString *oldPriority;
    
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
    
    CGPoint viewCenter;
}

@property (nonatomic,assign) id<TaskViewDelegate> delegate;
@property (retain, nonatomic) Task *task;
@property (retain, nonatomic) UITextField   *subjectTextField;
@property (retain, nonatomic) BodyTextView    *bodyTextView;
@property (assign, nonatomic) BOOL currentIsCompleted;
@property (retain, nonatomic) NSDate *currentDueDate;
@property (retain, nonatomic) DateLabel *dueDateLabel;
@property (retain, nonatomic) NSString *currentPriority;
@property (retain, nonatomic) PriorityButton *priorityButton;
@property (retain, nonatomic) CustomButton *statusButton;
@property (retain, nonatomic) NSString* currentTasklistId;
@property (retain, nonatomic) UITableViewCell *bodyCell;

@end
