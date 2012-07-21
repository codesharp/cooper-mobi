//
//  TaskViewController.h
//  Cooper
//
//  Created by sunleepy on 12-6-29.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "DetailViewController.h"
#import "TaskViewCell.h"
#import "TaskService.h"
#import "ModelHelper.h"
#import "TaskIdx.h"
#import "TaskViewDelegate.h"

@class TaskDao;
@class TaskIdxDao;
@class ChangeLogDao;

@interface TaskViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate,  NetworkDelegate, TaskViewDelegate>
{
    MBProgressHUD *HUD;
    
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
    
    int requestType;
}
@property (nonatomic, retain) NSMutableArray *taskIdxGroup;
@property (nonatomic, retain) NSMutableArray *taskGroup;
@property (nonatomic, retain) NSMutableArray *filteredtaskGroup;

@property (nonatomic, retain) NSString *filterStatus;

- (void) loadTaskData;
//@property (nonatomic, copy) NSString *savedSearchTerm;
//@property (nonatomic) NSInteger savedScopeButtonIndex;
//@property (nonatomic) BOOL searchWasActive;

@end
