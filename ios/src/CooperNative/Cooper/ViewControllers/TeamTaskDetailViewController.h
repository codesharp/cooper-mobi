//
//  TeamTaskDetailViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-9-20.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "WebViewController.h"
#import "BaseNavigationController.h"
#import "TeamTaskOptionViewController.h"
#import "TeamTaskDetailEditViewController.h"
#import "TeamTaskViewDelegate.h"
#import "CommentTextField.h"
#import "PriorityButton.h"
#import "DateLabel.h"
#import "CodesharpSDK/JSCoreTextView.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/TaskIdxDao.h"
#import "CooperRepository/ChangeLogDao.h"
#import "CooperRepository/TeamMemberDao.h"
#import "CooperRepository/ProjectDao.h"
#import "CooperRepository/TagDao.h"
#import "CooperRepository/CommentDao.h"

@interface TeamTaskDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, CommentTextFieldDelegate, TeamTaskViewDelegate, DateLabelDelegate, PriorityButtonDelegate>
{
    UITableView *detailView;
    UIView *assigneeView;
    UIView *projectView;
    UIView *tagView;
    UIView *footerView;
    
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
    TeamMemberDao *teamMemberDao;
    ProjectDao *projectDao;
    TagDao *tagDao;
    CommentDao *commentDao;
    
    UIButton *editBtn;
}

@property(nonatomic,assign) id<TeamTaskViewDelegate> delegate;
@property (retain, nonatomic) Task *task;
@property (retain, nonatomic) NSMutableArray *taskCommentArray;
@property (retain, nonatomic) DateLabel *dueDateLabel;
@property (retain, nonatomic) PriorityButton *priorityButton;
@property (retain, nonatomic) CustomButton *statusButton;
@property (retain, nonatomic) UILabel *subjectLabel;
@property (retain, nonatomic) JSCoreTextView *bodyLabel;
@property (retain, nonatomic) CommentTextField *commentTextField;
@property (retain, nonatomic) NSString *currentTeamId;
@property (retain, nonatomic) NSString *currentProjectId;
@property (retain, nonatomic) NSString *currentMemberId;
@property (retain, nonatomic) NSString *currentTag;

@property (retain, nonatomic) TeamTaskOptionViewController *teamTaskOptionViewController;
@property (retain, nonatomic) BaseNavigationController *teamTaskDetailEdit_NavController;
@property (retain, nonatomic) TeamTaskDetailEditViewController *teamTaskDetailEditViewController;

@end
