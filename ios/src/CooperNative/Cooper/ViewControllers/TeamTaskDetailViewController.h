//
//  TeamTaskDetailViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-9-20.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

//#import "TaskDetailEditViewController.h"
#import "WebViewController.h"
#import "BaseNavigationController.h"
#import "TeamTaskViewDelegate.h"
#import "CommentTextField.h"
#import "PriorityButton.h"
#import "DateLabel.h"
#import "CodesharpSDK/JSCoreTextView.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/TaskIdxDao.h"
#import "CooperRepository/ChangeLogDao.h"

@interface TeamTaskDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, CommentTextFieldDelegate, TeamTaskViewDelegate, DateLabelDelegate, PriorityButtonDelegate>
{
    UITableView *detailView;
    UIView *footerView;
    
    UIScrollView *_scrollView;
    
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
}

@property(nonatomic,assign) id<TeamTaskViewDelegate> delegate;
@property (retain, nonatomic) Task *task;
@property (retain, nonatomic) DateLabel *dueDateLabel;
@property (retain, nonatomic) PriorityButton *priorityButton;
@property (retain, nonatomic) CustomButton *statusButton;
@property (retain, nonatomic) UILabel *subjectLabel;
@property (retain, nonatomic) JSCoreTextView *bodyLabel;
@property (retain, nonatomic) CommentTextField *commentTextField;
@property (retain, nonatomic) NSString* currentTeamId;

@end
