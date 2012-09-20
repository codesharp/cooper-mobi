//
//  TeamTaskFilterViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-9-20.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"
#import "TeamTaskViewDelegate.h"
#import "TeamTaskFilterLabel.h"
#import "CooperRepository/TeamMemberDao.h"
#import "CooperRepository/ProjectDao.h"
#import "CooperRepository/TagDao.h"

@interface TeamTaskFilterViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, TeamTaskFilterLabelDelegate>
{
    UITableView *filterView;
    UIScrollView *scrollView;
    UITableView *filterOptionView;
    
    TeamMemberDao *teamMemberDao;
    ProjectDao *projectDao;
    TagDao *tagDao;
    
    NSInteger currentIndex;
    NSString *currentProjectId;
    NSString *currentMemberId;
    NSString *currentTag;
}
@property (nonatomic, assign) id<TeamTaskViewDelegate> delegate;
@property (nonatomic, retain) TeamTaskFilterLabel *teamTaskFilterLabel;
@property (nonatomic, retain) NSString *currentTeamId;
@property (nonatomic, retain) NSMutableArray *filterOptionArray;

@end
