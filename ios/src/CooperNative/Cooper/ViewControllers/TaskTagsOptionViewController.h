//
//  TaskTagsOptionViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-10-22.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"
#import "InputPickerView.h"
#import "CooperCore/Task.h"
#import "CooperRepository/TaskDao.h"
#import "CooperRepository/ChangeLogDao.h"
#import "TaskDetailEditViewDelegate.h"

@interface TaskTagsOptionViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, InputPickerDelegate>
{
    UITableView *tagsView;
    InputPickerView *editBtn;
    
    TaskDao *taskDao;
    ChangeLogDao *changeLogDao;
}

@property (nonatomic, assign) id<TaskDetailEditViewDelegate> delegate;
@property (nonatomic, retain) NSString* currentTasklistId;
@property (nonatomic, retain) Task *currentTask;
@property (nonatomic, retain) NSMutableArray *tagsArray;

@end
