//
//  TeamTaskOptionViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-9-21.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"
#import "TeamTaskDetailEditViewDelegate.h"
#import "CooperRepository/TeamMemberDao.h"
#import "CooperRepository/ProjectDao.h"
#import "CooperRepository/TagDao.h"
#import "CooperRepository/ChangeLogDao.h"
#import "CooperCore/Task.h"

@interface TeamTaskOptionViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *optionView;
    
    TeamMemberDao *teamMemberDao;
    ProjectDao *projectDao;
    TagDao *tagDao;
    ChangeLogDao *changeLogDao;
}

@property (nonatomic, assign) id<TeamTaskDetailEditViewDelegate> delegate;
@property (nonatomic, assign) NSInteger optionType;
@property (nonatomic, assign) BOOL selectMultiple;
@property (nonatomic, retain) Task *currentTask;
@property (nonatomic, retain) NSString *currentTeamId;
@property (nonatomic, retain) NSString *currentProjectId;
@property (nonatomic, retain) NSString *currentMemberId;
@property (nonatomic, retain) NSString *currentTag;
@property (nonatomic, retain) NSString *currentIndexs;
@property (nonatomic, retain) NSMutableArray *optionArray;

@end
