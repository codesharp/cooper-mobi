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

@interface TaskTagsOptionViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tagsView;
    InputPickerView *editBtn;
}
@property (nonatomic, retain) Task *currentTask;
@property (nonatomic, retain) NSMutableArray *tagsArray;

@end
