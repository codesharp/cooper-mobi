//
//  TasklistViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

//#import "BaseViewController.h"
#import "CustomToolbar.h"
#import "Tasklist.h"
//#import "TasklistService.h"
#import "TaskViewController.h"
#import "TasklistEditController.h"
#import "InputPickerButton.h"

@class TasklistDao;

@interface TasklistViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,UITabBarControllerDelegate, InputPickerDelegate>
{
    MBProgressHUD *HUD;
    int requestType;
    InputPickerButton *editBtn;
}

@property (nonatomic,retain) NSMutableArray *tasklists;
@property (nonatomic,retain) TasklistDao *tasklistDao;
@property (nonatomic,retain) UITableView *tasklistTableView; 

@end
