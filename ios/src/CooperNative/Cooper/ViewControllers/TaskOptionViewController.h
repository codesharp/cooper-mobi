//
//  TaskOptionViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-9-13.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "TasklistViewController.h"
#import "TeamViewController.h"
#import "SettingViewController.h"

@interface TaskOptionViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *taskOptionView;
    UIButton *settingBtn;
}
@property (nonatomic, retain) TasklistViewController *tasklistViewController;
@property (nonatomic, retain) TeamViewController *teamViewController;
@property (nonatomic, retain) BaseNavigationController *setting_navViewController;

@end
