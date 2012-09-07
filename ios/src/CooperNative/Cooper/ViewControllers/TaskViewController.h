//
//  TaskViewController.h
//  Cooper
//
//  Created by sunleepy on 12-6-29.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CooperService/TaskService.h"
#import "TaskViewDelegate.h"
#import "BaseTableViewController.h"
#import "TaskTableViewCell.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/TaskIdxDao.h"
#import "CooperRepository/ChangeLogDao.h"
#import "CooperRepository/TasklistDao.h"
//#import "CodesharpSDK/MoveTableView.h"

@interface TaskViewController : BaseTableViewController<UISearchDisplayDelegate
    , UISearchBarDelegate
    , NetworkDelegate
    , TaskViewDelegate
    , TaskTableViewCellDelegate>
{
    MBProgressHUD *HUD;
    
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
    TasklistDao *tasklistDao;
    
    UIView *emptyView;
    UIView *editBtn;
    UIView *syncBtn;
    UIView *addBtn;
}
@property (nonatomic,retain) NSString* currentTasklistId;
@property (nonatomic, retain) NSMutableArray *taskIdxGroup;
@property (nonatomic, retain) NSMutableArray *taskGroup;

@property (nonatomic, retain) NSString *filterStatus;

- (void) loadTaskData;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
             setTitle:(NSString *)title 
             setImage:(NSString*)imageName;

@end
