//
//  TaskViewController.h
//  Cooper
//
//  Created by sunleepy on 12-6-29.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "TaskDetailEditViewController.h"
#import "TaskTableViewCell.h"
#import "TaskService.h"
#import "ModelHelper.h"
#import "TaskIdx.h"
#import "TaskViewDelegate.h"
#import "BaseTableViewController.h"

@class TaskDao;
@class TaskIdxDao;
@class ChangeLogDao;
@class TaskTableViewCellDelegate;

@interface TaskViewController : BaseTableViewController<UISearchDisplayDelegate, UISearchBarDelegate,  NetworkDelegate, TaskViewDelegate, TaskTableViewCellDelegate>
{
    MBProgressHUD *HUD;
    
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
    
    int requestType;
}
@property (nonatomic,retain) NSString* currentTasklistId;
@property (nonatomic, retain) NSMutableArray *taskIdxGroup;
@property (nonatomic, retain) NSMutableArray *taskGroup;

@property (nonatomic, retain) NSString *filterStatus;

- (void) loadTaskData;

@end
