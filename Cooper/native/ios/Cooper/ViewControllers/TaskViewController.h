//
//  TaskViewController.h
//  Cooper
//
//  Created by sunleepy on 12-6-29.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskService.h"
#import "TaskViewDelegate.h"
#import "BaseTableViewController.h"
#import "TaskTableViewCell.h"
#import "TaskDao.h"
#import "TaskIdxDao.h"
#import "ChangeLogDao.h"

@interface TaskViewController : BaseTableViewController<UISearchDisplayDelegate
    , UISearchBarDelegate
    , NetworkDelegate
    , TaskViewDelegate
    , TaskTableViewCellDelegate
>
{
    MBProgressHUD *HUD;
    
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
    
    TaskRequestType requestType;
}
@property (nonatomic,retain) NSString* currentTasklistId;
@property (nonatomic, retain) NSMutableArray *taskIdxGroup;
@property (nonatomic, retain) NSMutableArray *taskGroup;

@property (nonatomic, retain) NSString *filterStatus;

- (void) loadTaskData;

@end
