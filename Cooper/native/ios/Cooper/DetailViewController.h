//
//  DetailViewController.h
//  Cooper
//
//  Created by sunleepy on 12-6-29.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CommentViewController.h"
#import "PriorityViewController.h"
#import "Task.h"
#import "TaskViewDelegate.h"

@class TaskDao;
@class TaskIdxDao;
@class ChangeLogDao;
@class AppDelegate;

@interface DetailViewController : UITableViewController<UITextViewDelegate,UITextFieldDelegate>
{
    UIView *tempView;
    NSString *oldPriority;
    TaskDao *taskDao;
    TaskIdxDao *taskIdxDao;
    ChangeLogDao *changeLogDao;
}

@property(nonatomic,assign) id<TaskViewDelegate> delegate;
@property (strong, nonatomic) CommentViewController *commentViewController;
@property (retain, nonatomic) Task *task;

@end
