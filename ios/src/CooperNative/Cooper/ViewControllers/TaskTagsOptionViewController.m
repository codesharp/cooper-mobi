//
//  TaskTagsOptionViewController.m
//  CooperNative
//
//  Created by sunleepy on 12-10-22.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TaskTagsOptionViewController.h"

@implementation TaskTagsOptionViewController

@synthesize currentTasklistId;
@synthesize currentTask;
@synthesize tagsArray;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    taskDao = [[TaskDao alloc] init];
    changeLogDao = [[ChangeLogDao alloc] init];

    [self initContentView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
    
    [tagsView release];
    [taskDao release];
    [changeLogDao release];
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
    return tagsArray.count;
}
//填充单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell"];
    if(!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TagCell"] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *tagName = [tagsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = tagName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//点击标准编辑按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *tag = [[tagsArray objectAtIndex:indexPath.row] copy];
   
        [tagsArray removeObjectAtIndex:indexPath.row];
        
        if(currentTask != nil)
        {
            currentTask.tags = [tagsArray JSONRepresentation];
            [changeLogDao insertChangeLog:[NSNumber numberWithInt:1]
                                   dataid:currentTask.id
                                     name:@"tags"
                                    value:tag
                               tasklistId:currentTasklistId];
            
            [taskDao commitData];
        }
        [delegate modifyTags:[[tagsArray JSONRepresentation] copy]];
 
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
 
    }
    else
    {
        
    }
}

#pragma mark - 自定义方法

- (void)initContentView
{
    self.title = @"标签选择";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5, 5, 25, 25)];
    [backBtn setBackgroundImage:[UIImage imageNamed:BACK_IMAGE] forState:UIControlStateNormal];
    [backBtn addTarget: self action: @selector(back:) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtn] autorelease];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    editBtn = [[InputPickerView alloc] initWithFrame:CGRectMake(0, 0, 38, 45)];
    editBtn.placeHolderText = @"标签名称";
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 27, 27)];
    UIImage *editImage = [UIImage imageNamed:EDIT_IMAGE];
    imageView.image = editImage;
    [editBtn addSubview:imageView];
    [imageView release];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTag:)];
    [editBtn addGestureRecognizer:recognizer];
    editBtn.delegate = self;
    [recognizer release];
    
    UIBarButtonItem *editButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editBtn] autorelease];
    self.navigationItem.rightBarButtonItem = editButtonItem;

    CGRect tableViewRect = CGRectMake(0, 0, [Tools screenMaxWidth], [Tools screenMaxHeight]);
    tagsView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    tagsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tagsView.backgroundColor = [UIColor whiteColor];
    
    //去掉底部空白
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    tagsView.tableFooterView = footer;
    tagsView.delegate = self;
    tagsView.dataSource = self;
    
    [self.view addSubview:tagsView];
}

- (void)back:(id)sender
{
    [Tools layerTransition:self.navigationController.view from:@"left"];
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)addTag:(id)sender
{
    [editBtn becomeFirstResponder];
}
- (void)send:(NSString *)tagName
{
    NSLog(@"添加标签: %@", tagName);
    
    for (NSString *tag in tagsArray)
    {
        if([tag caseInsensitiveCompare:tagName] == NSOrderedSame)
        {
            [editBtn resignFirstResponder];
            return;
        }
    }
    [tagsArray addObject:tagName];
    [editBtn resignFirstResponder];
    [tagsView reloadData];
    
    if(currentTask != nil)
    {
        currentTask.tags = [tagsArray JSONRepresentation];
        
        [changeLogDao insertChangeLog:[NSNumber numberWithInt:2]
                               dataid:currentTask.id
                                 name:@"tags"
                                value:tagName
                           tasklistId:currentTasklistId];
        
        [taskDao commitData];
    }
    [delegate modifyTags:[[tagsArray JSONRepresentation] copy]];
}

@end
