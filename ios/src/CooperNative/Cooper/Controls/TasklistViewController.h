//
//  TasklistViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CustomToolbar.h"
#import "CooperCore/Tasklist.h"
#import "InputPickerButton.h"
#import "InputPickerView.h"
#import "BaseViewController.h"
#import "CooperRepository/TasklistDao.h"

#define RECENTLYTASKLIST_COUNT  4

@interface TasklistViewController : BaseViewController<UITableViewDelegate
    , UITableViewDataSource
    , UITabBarControllerDelegate
    , InputPickerDelegate
>
{
    MBProgressHUD *HUD;
    InputPickerView *editBtn;
    UIView *syncBtn;
    UIButton *settingBtn;
    TasklistDao *tasklistDao;
    
    NSString* tempTasklistId;
}

@property (nonatomic, retain) NSMutableArray *tasklists;
@property (nonatomic, retain) UITableView *tasklistTableView; 

@end
