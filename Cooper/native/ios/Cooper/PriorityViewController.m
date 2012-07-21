//
//  PriorityViewController.m
//  Cooper
//
//  Created by sunleepy on 12-7-3.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import "PriorityViewController.h"

@interface PriorityViewController ()

@end

@implementation PriorityViewController

@synthesize priorityList;
@synthesize currentcell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.priorityList == nil)
    {
        self.priorityList = [NSMutableArray array];
        
        [self.priorityList addObject:@"今天"];
        [self.priorityList addObject:@"稍后完成"];
        [self.priorityList addObject:@"迟些再说"];
    }
    
    NSLog(@"%d", priorityList.count);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    NSLog(@"dealloc:");
    [self.priorityList release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"优先级选择";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PriorityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PriorityCell"] autorelease];
    }
    cell.textLabel.text = (NSString*)[self.priorityList objectAtIndex:indexPath.row];
    cell.accessoryType = [self.currentcell.detailTextLabel.text isEqualToString:cell.textLabel.text] ?
        UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for(int i = 0; i < self.priorityList.count; i++)
    {
        UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.currentcell.detailTextLabel.text = cell.textLabel.text;
}

@end
