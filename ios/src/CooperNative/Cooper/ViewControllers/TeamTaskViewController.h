//
//  TeamTaskViewController.h
//  CooperNative
//
//  Created by sunleepy on 12-9-17.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseViewController.h"
#import "SettingViewController.h"
#import "CooperService/TeamService.h"
#import "CooperRepository/TeamDao.h"
#import "CooperRepository/TeamMemberDao.h"
#import "CooperRepository/ProjectDao.h"
#import "CooperRepository/TagDao.h"
#import "CustomButton.h"

@interface TeamTaskViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *taskView;
    
    TeamService *teamService;
    
    TeamDao *teamDao;
    TeamMemberDao *teamMemberDao;
    ProjectDao *projectDao;
    TagDao *tagDao;
    
    UIView *editBtn;
    UIView *syncBtn;
    UIView *addBtn;
    UIView *settingBtn;
    
    UIView *statusView;
    UILabel *filterLabel;
    CustomButton *doneEditingBtn;
}

@property (nonatomic, retain) NSString* currentTeamId;
@property (nonatomic, retain) NSMutableArray *taskIdxGroup;
@property (nonatomic, retain) NSMutableArray *taskGroup;
@property (nonatomic, retain) SettingViewController *settingViewController;

@end
