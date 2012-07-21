//
//  SettingViewController.m
//  Cooper
//
//  Created by 磊 李 on 12-7-12.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "SettingViewController.h"
#import "PathViewController.h"
#import "AccountViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"设置", @"设置");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PathEnvironmentCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PathEnvironmentCell"] autorelease];
                
                cell.textLabel.text = @"同步设置";
                //cell.detailTextLabel.text = [[Constant instance] path];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.editingAccessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if(indexPath.row == 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AccountCell"] autorelease];
                
                cell.textLabel.text = @"Ark帐号设置";
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.editingAccessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if(indexPath.row == 2)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ApplicationCell"];
            if(!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"applicationCell"] autorelease];
                
                cell.textLabel.text = @"版本检测";
                cell.detailTextLabel.text = @"v1.0";
                
                //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                //cell.editingAccessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
                                                                                  
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            PathViewController *pathViewController = [[[PathViewController alloc] initWithNibName:@"PathViewController" bundle:nil] autorelease];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [self.navigationController pushViewController:pathViewController animated:YES];
        }
        else if(indexPath.row == 1)
        {
            AccountViewController *accountViewController = [[[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil] autorelease];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [self.navigationController pushViewController:accountViewController animated:YES];
        }
        else if(indexPath.row == 2)
        {
            
        }
    }
}

-(void)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

@end
