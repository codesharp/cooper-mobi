//
//  TaskDetailViewController.h
//  Cooper
//
//  Created by Ping Li on 12-7-24.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskDetailEditViewController.h"
#import "CodesharpSDK/JSCoreTextView.h"
#import "WebViewController.h"
#import "BaseNavigationController.h"

@interface TaskDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, CommentTextFieldDelegate, TaskViewDelegate, DateLabelDelegate, PriorityButtonDelegate>
{
    UITableView *detailView;
    UIView *footerView;
    
    UIScrollView *_scrollView;
    
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
//@property (retain, nonatomic) UILabel *bodyLabel;
@property (retain, nonatomic) JSCoreTextView *bodyLabel;
@property (retain, nonatomic) CommentTextField *commentTextField;
@property (retain, nonatomic) NSString* currentTasklistId;

- (void) initContentView;

@end
