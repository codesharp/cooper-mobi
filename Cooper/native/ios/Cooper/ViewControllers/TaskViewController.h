//
//  TaskViewController.h
//  Cooper
//
//  Created by sunleepy on 12-6-29.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "DetailViewController.h"
#import "TaskDetailViewController.h"
#import "TaskDetailEditViewController.h"
#import "TaskTableViewCell.h"
#import "TaskService.h"
#import "ModelHelper.h"
#import "TaskIdx.h"
#import "TaskViewDelegate.h"

@class TaskDao;
@class TaskIdxDao;
@class ChangeLogDao;
@class TaskTableViewCellDelegate;

@interface TaskViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate,  NetworkDelegate, TaskViewDelegate, TaskTableViewCellDelegate>
{
    MBProgressHUD *HUD;
    
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
    
    int requestType;
}
@property (nonatomic, retain) NSMutableArray *taskIdxGroup;
@property (nonatomic, retain) NSMutableArray *taskGroup;

@property (nonatomic, retain) NSString *filterStatus;

- (void) loadTaskData;

@end
