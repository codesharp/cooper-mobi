//
//  TasklistViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "InputPickerView.h"
#import "BaseViewController.h"
#import "CooperRepository/TasklistDao.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/TaskIdxDao.h"
#import "CooperRepository/ChangeLogDao.h"
#import "CooperService/TasklistNewService.h"
#import "CooperService/TaskNewService.h"
#import "CodesharpSDK/ASINetworkQueue.h"

#define RECENTLYTASKLIST_COUNT  4

@interface TasklistViewController : BaseViewController<UITableViewDelegate
    , UITableViewDataSource
    , UITabBarControllerDelegate
    , InputPickerDelegate
//    , HttpWebRequestDelegate
>
{
    UIView *backBtn;
    InputPickerView *editBtn;
    UIView *syncBtn;
    UIButton *settingBtn;
    UITableView *tasklistTableView;
    
    TasklistNewService *tasklistService;
    TaskNewService *taskService;
    ASINetworkQueue *networkQueue;
    
    TasklistDao *tasklistDao;
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
}

@property (nonatomic, retain) NSMutableArray *tasklists;

@end
