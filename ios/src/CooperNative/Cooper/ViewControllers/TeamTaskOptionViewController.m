//
//  TeamTaskOptionViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-9-21.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TeamTaskOptionViewController.h"
#import "CustomButton.h"

@implementation TeamTaskOptionViewController

@synthesize optionType;
@synthesize selectMultiple;
@synthesize currentTask;
@synthesize optionArray;
@synthesize currentTeamId;
@synthesize currentProjectId;
@synthesize currentMemberId;
@synthesize currentTag;
@synthesize currentIndexs;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    teamMemberDao = [[TeamMemberDao alloc] init];
    projectDao = [[ProjectDao alloc] init];
    tagDao = [[TagDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];
    optionArray = [NSMutableArray array];
    
    currentIndexs = @"";
    
    [self initContentView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadOptionData];
}

- (void)dealloc
{
    [super dealloc];
    
    [teamMemberDao release];
    [projectDao release];
    [tagDao release];
    [changeLogDao release];
    [optionView release];
    [optionArray release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - tableView 数据源

//获取TableView的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//获取在制定的分区编号下的纪录数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return optionArray.count;
}
//填充单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"OptionCell"];
    if(!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OptionCell"] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *array = [currentIndexs componentsSeparatedByString:@","];
    NSString *row = [NSString stringWithFormat:@"%d",indexPath.row];
    if([array containsObject:row])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSObject *idObject = [optionArray objectAtIndex:indexPath.row];
    if([idObject isKindOfClass:[TeamMember class]])
    {
        TeamMember *teamMember = (TeamMember*)idObject;
        cell.textLabel.text = teamMember.name;
    }
    else if([idObject isKindOfClass:[Project class]])
    {
        Project *project = (Project*)idObject;
        cell.textLabel.text = project.name;
    }
    else if([idObject isKindOfClass:[Tag class]])
    {
        Tag *tag = (Tag*)idObject;
        cell.textLabel.text = tag.name;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectMultiple)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        if (newCell.accessoryType == UITableViewCellAccessoryNone)
        {
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            newCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else
    {
        if([currentIndexs isEqualToString:@""])
        {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            if (newCell.accessoryType == UITableViewCellAccessoryNone)
            {
                newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        else
        {
            NSInteger currentIndex = [currentIndexs integerValue];
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
            
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            if (newCell.accessoryType == UITableViewCellAccessoryNone)
            {
                newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
            if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark)
            {
                oldCell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        currentIndexs = [[NSString stringWithFormat:@"%d", indexPath.row] copy];
    }
}

#pragma mark - 事件动作

- (void)initContentView
{
    self.title = @"条件筛选";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:BACK_IMAGE] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(back:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtn] autorelease];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    CustomButton *saveTaskBtn = [[[CustomButton alloc] initWithFrame:CGRectMake(5,5,50,30) image:[UIImage imageNamed:@"btn_center.png"]] autorelease];
    saveTaskBtn.layer.cornerRadius = 6.0f;
    [saveTaskBtn.layer setMasksToBounds:YES];
    [saveTaskBtn addTarget:self action:@selector(saveOption:) forControlEvents:UIControlEventTouchUpInside];
    [saveTaskBtn setTitle:@"确定" forState:UIControlStateNormal];
    UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] initWithCustomView:saveTaskBtn] autorelease];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    CGRect tableViewRect = CGRectMake(0, 0, [Tools screenMaxWidth], [Tools screenMaxHeight]);
    UITableView* tempTableView = [[[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain] autorelease];
    tempTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tempTableView setBackgroundColor:[UIColor whiteColor]];
    
    //去掉底部空白
    UIView *footer =
    [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    tempTableView.tableFooterView = footer;
    [footer release];
    
    optionView = tempTableView;
    optionView.delegate = self;
    optionView.dataSource = self;
    
    [self.view addSubview:optionView];
    
    [tempTableView release];
}

- (void)loadOptionData
{
    currentIndexs = @"";
    
    if(optionType == 1)
    {
        optionArray = [teamMemberDao getListByTeamId:currentTeamId];

        for (NSInteger i = 0; i < optionArray.count; i++)
        {
            TeamMember *teamMember = [optionArray objectAtIndex:i];
            if([teamMember.id isEqualToString:currentTask.assigneeId])
            {
                currentIndexs = [[NSString stringWithFormat:@"%d", i] copy];
                break;
            }     
        }
    }
    else if(optionType == 2)
    {
        optionArray = [projectDao getListByTeamId:currentTeamId];
        
        for (NSInteger i = 0; i < optionArray.count; i++)
        {
            Project *project = [optionArray objectAtIndex:i];
            if(currentTask.projects != nil)
            {
                NSMutableArray *projectArray = [currentTask.projects JSONValue];
                if(projectArray.count > 0)
                {
                    for (NSInteger j = 0; j < projectArray.count; j++)
                    {
                        NSMutableDictionary *projectDict = [projectArray objectAtIndex:j];
                        
                        if([project.id isEqualToString:[projectDict objectForKey:@"id"]])
                        {
                            currentIndexs = [[NSString stringWithFormat:@"%@%@"
                                              , currentIndexs
                                              , [NSString stringWithFormat:@"%d,", i]] copy];
                            break;
                        }
                    }
                }
            }
        }
    }
    else if(optionType == 3)
    {
        optionArray = [tagDao getListByTeamId:currentTeamId];
        
        for (NSInteger i = 0; i < optionArray.count; i++)
        {
            Tag *tag = [optionArray objectAtIndex:i];
            if(currentTask.tags != nil)
            {
                NSMutableArray *tagArray = [currentTask.tags JSONValue];
                if(tagArray.count > 0)
                {
                    for (NSInteger j = 0; j < tagArray.count; j++)
                    {
                        NSString *tagName = [tagArray objectAtIndex:j];
                        
                        if([tag.name isEqualToString:tagName])
                        {
                            currentIndexs = [[NSString stringWithFormat:@"%@%@"
                                              , currentIndexs
                                              , [NSString stringWithFormat:@"%d,", i]] copy];
                            break;
                        }
                    }
                }
            }
        }
    }
    
    [optionView reloadData];
}

- (void)back:(id)sender
{
    [Tools layerTransition:self.navigationController.view from:@"left"];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)saveOption:(id)sender
{
    if(optionType == 1)
    {
        for (NSInteger i = 0; i < optionArray.count; i++)
        {
            UITableViewCell *cell = [optionView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
            {
                TeamMember *teamMember = [optionArray objectAtIndex:i];
                if(teamMember != nil)
                {
                    if(currentTask != nil)
                    {
                        currentTask.assigneeId = teamMember.id;
                        [teamMemberDao commitData];
                        
                        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:0]
                                                     dataId:currentTask.id
                                                       name:@"assigneeid"
                                                      value:currentTask.assigneeId
                                                     teamId:currentTeamId
                                                  projectId:currentProjectId
                                                   memberId:currentMemberId
                                                        tag:currentTag];
                        [changeLogDao commitData];
                    }

                    [delegate modifyAssignee:teamMember.id];
                    
                    [self back:nil];
                    return;
                }
            }
        }
        if(currentTask != nil)
        {
            currentTask.assigneeId = nil;
        }
        [delegate modifyAssignee:nil];
    }
    else if(optionType == 2)
    {
        NSMutableArray *projectOldArray = [currentTask.projects JSONValue];
        if(projectOldArray.count > 0)
        {
            for (NSMutableDictionary *projectDict in projectOldArray)
            {
                NSString *projectId = [projectDict objectForKey:@"id"];
                [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:1]
                                             dataId:currentTask.id
                                               name:@"projects"
                                              value:projectId
                                             teamId:currentTeamId
                                          projectId:currentProjectId
                                           memberId:currentMemberId
                                                tag:currentTag];
            }
            [changeLogDao commitData];
        }
        
        NSMutableArray *projectArray = [NSMutableArray array];
        for (NSInteger i = 0; i < optionArray.count; i++)
        {
            UITableViewCell *cell = [optionView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
            {
                Project *project = [optionArray objectAtIndex:i];
                if(project != nil)
                {
                    NSMutableDictionary *projectDict = [NSMutableDictionary dictionary];
                    [projectDict setObject:project.id forKey:@"id"];
                    [projectDict setObject:project.name forKey:@"name"];
                    [projectArray addObject:projectDict];
                    
                    if(currentTask != nil)
                    {
                        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:2]
                                                     dataId:currentTask.id
                                                       name:@"projects"
                                                      value:project.id
                                                     teamId:currentTeamId
                                                  projectId:currentProjectId
                                                   memberId:currentMemberId
                                                        tag:currentTag];
                        [changeLogDao commitData];
                    }
                }
            }
        }
        
        if(currentTask != nil)
        {
            currentTask.projects = [projectArray JSONRepresentation];
            [projectDao commitData];
        }
        [delegate modifyProjects:[[projectArray JSONRepresentation] copy]];
    }
    else if(optionType == 3)
    {
        NSMutableArray *tagOldArray = [currentTask.tags JSONValue];
        if(tagOldArray.count > 0)
        {
            for (NSString *tagName in tagOldArray)
            {
                [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:1]
                                             dataId:currentTask.id
                                               name:@"tags"
                                              value:tagName
                                             teamId:currentTeamId
                                          projectId:currentProjectId
                                           memberId:currentMemberId
                                                tag:currentTag];
            }
            [changeLogDao commitData];
        }
        
        NSMutableArray *tagArray = [NSMutableArray array];
        for (NSInteger i = 0; i < optionArray.count; i++)
        {
            UITableViewCell *cell = [optionView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
            {
                Tag *tag = [optionArray objectAtIndex:i];
                if(tag != nil)
                {
                    [tagArray addObject:tag.name];
                    
                    if(currentTask != nil)
                    {
                        [changeLogDao insertChangeLogByTeam:[NSNumber numberWithInt:2]
                                                     dataId:currentTask.id
                                                       name:@"tags"
                                                      value:tag.name
                                                     teamId:currentTeamId
                                                  projectId:currentProjectId
                                                   memberId:currentMemberId
                                                        tag:currentTag];
                        [changeLogDao commitData];
                    }
                }
            }
        }
        
        if(currentTask != nil)
        {
            currentTask.tags = [tagArray JSONRepresentation];
            [tagDao commitData];
        }
        [delegate modifyTags:[[tagArray JSONRepresentation] copy]];
    }

    [self back:nil];
}

@end
