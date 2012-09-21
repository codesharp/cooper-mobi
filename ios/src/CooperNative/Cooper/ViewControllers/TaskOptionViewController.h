//
//  TaskOptionViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-9-13.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "TasklistViewController.h"
#import "TeamTaskViewController.h"
#import "TeamViewController.h"
#import "SettingViewController.h"
#import "CooperRepository/TasklistDao.h"
#import "CooperRepository/TeamDao.h"

#define RECENTLY_COUNT  8

@interface TaskOptionViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *taskOptionView;
    UIButton *settingBtn;
    
    TeamDao *teamDao;
    TasklistDao *tasklistDao;
}

@property (nonatomic, retain) NSMutableArray *tasklists;
@property (nonatomic, retain) NSMutableArray *teams;

@property (nonatomic, retain) TasklistViewController *tasklistViewController;
@property (nonatomic, retain) TeamViewController *teamViewController;
@property (nonatomic, retain) BaseNavigationController *setting_navViewController;
@property (nonatomic, retain) TeamTaskViewController *teamTaskViewController;

@end
