//
//  TasklistEditController.h
//  Cooper
//
//  Created by sunleepy on 12-7-29.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"

#import "TasklistDao.h"

@interface TasklistEditController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    MBProgressHUD *HUD;
    
    UITableView *tasklistTableView;
    
    TasklistDao *tasklistDao;
}

@property (retain, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) NSString *tempTasklistId;

@end
