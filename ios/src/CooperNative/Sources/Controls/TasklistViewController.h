//
//  TasklistViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CustomToolbar.h"
#import "Tasklist.h"
#import "InputPickerButton.h"
#import "BaseViewController.h"
#import "TasklistDao.h"

#define RECENTLYTASKLIST_COUNT  4

@interface TasklistViewController : BaseViewController<UITableViewDelegate
    , UITableViewDataSource
    , UITabBarControllerDelegate
    , InputPickerDelegate
>
{
    MBProgressHUD *HUD;
    TasklistRequestType requestType;
    InputPickerButton *editBtn;
    UIButton *syncBtn;
    TasklistDao *tasklistDao;
    
    NSString* tempTasklistId;
}

@property (nonatomic, retain) NSMutableArray *tasklists;
@property (nonatomic, retain) UITableView *tasklistTableView; 
//@property (nonatomic, retain) NSString* tempTasklistId;

@end
