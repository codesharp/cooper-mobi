//
//  TeamTaskViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-9-17.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"
#import "SettingViewController.h"
#import "TeamTaskFilterViewController.h"
#import "TeamTaskDetailViewController.h"
#import "TaskViewDelegate.h"
#import "TeamTaskViewDelegate.h"
#import "TaskTableViewCell.h"
#import "CustomButton.h"
#import "CooperService/TeamService.h"
#import "CooperRepository/TeamDao.h"
#import "CooperRepository/TeamMemberDao.h"
#import "CooperRepository/ProjectDao.h"
#import "CooperRepository/TagDao.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/TaskIdxDao.h"
#import "CooperRepository/ChangeLogDao.h"
#import "CooperRepository/CommentDao.h"

@interface TeamTaskViewController : BaseViewController<TeamTaskViewDelegate, UITableViewDataSource, UITableViewDelegate, TaskTableViewCellDelegate>
{
    UIView *emptyView;
    UITableView *taskView;
    
    TeamService *teamService;
    
    TeamDao *teamDao;
    TeamMemberDao *teamMemberDao;
    ProjectDao *projectDao;
    TagDao *tagDao;
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
    CommentDao *commentDao;
    
    UIView *editBtn;
    UIView *syncBtn;
    UIView *addBtn;
    UIView *settingBtn;
    
    UIView *statusView;
    UILabel *filterLabel;
    CustomButton *doneEditingBtn;
}

@property (nonatomic, retain) NSString *currentTeamId;
@property (nonatomic, retain) NSString *currentProjectId;
@property (nonatomic, retain) NSString *currentMemberId;
@property (nonatomic, retain) NSString *currentTag;

@property (nonatomic, assign) BOOL needSync;

@property (nonatomic, retain) NSMutableArray *taskIdxGroup;
@property (nonatomic, retain) NSMutableArray *taskGroup;
@property (nonatomic, retain) SettingViewController *settingViewController;
@property (nonatomic, retain) TeamTaskFilterViewController *teamTaskFilterViewController;
@property (nonatomic, retain) TeamTaskDetailViewController *teamTaskDetailViewController;

@end
