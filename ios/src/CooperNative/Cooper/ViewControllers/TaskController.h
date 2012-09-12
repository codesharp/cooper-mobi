//
//  TaskController.h
//  CooperNative
//
//  Created by sunleepy on 12-9-7.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"
#import "TaskViewDelegate.h"
#import "TaskTableViewCell.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/TaskIdxDao.h"
#import "CooperRepository/ChangeLogDao.h"
#import "CooperRepository/TasklistDao.h"
#import "CooperService/TasklistNewService.h"
#import "CooperService/TaskNewService.h"
#import "CustomButton.h"

@interface TaskController : BaseViewController<UITableViewDelegate, UITableViewDataSource, TaskTableViewCellDelegate>
{
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
    TasklistDao *tasklistDao;
    
    TasklistNewService *tasklistService;
    TaskNewService *taskService;
    
    UIView *emptyView;
    UITableView *taskView;
    
    UIView *editBtn;
    UIView *syncBtn;
    UIView *addBtn;
    CustomButton *doneEditingBtn;
}

@property (nonatomic, retain) NSString* currentTasklistId;
@property (nonatomic, retain) NSMutableArray *taskIdxGroup;
@property (nonatomic, retain) NSMutableArray *taskGroup;

@property (nonatomic, retain) NSString *filterStatus;

- (void) loadTaskData;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             setTitle:(NSString *)title
             setImage:(NSString*)imageName;

@end
