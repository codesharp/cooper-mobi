//
//  TasklistViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-27.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

//#import "BaseViewController.h"
#import "CustomToolbar.h"
#import "Tasklist.h"
//#import "TasklistService.h"
#import "TaskViewController.h"
#import "TasklistEditController.h"

@class TasklistDao;

@interface TasklistViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,UITabBarControllerDelegate>
{
    MBProgressHUD *HUD;
    int requestType;
}

@property (nonatomic,retain) NSMutableArray *tasklists;
@property (nonatomic,retain) TasklistDao *tasklistDao;
@property (nonatomic,retain) UITableView *tasklistTableView; 

@end
