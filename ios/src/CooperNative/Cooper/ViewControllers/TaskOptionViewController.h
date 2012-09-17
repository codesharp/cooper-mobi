//
//  TaskOptionViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-9-13.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"
#import "TasklistViewController.h"
#import "TeamViewController.h"

@interface TaskOptionViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *taskOptionView;
    UIButton *settingBtn;
}
@property (nonatomic, retain) TasklistViewController *tasklistViewController;
@property (nonatomic, retain) TeamViewController *teamViewController;

@end
