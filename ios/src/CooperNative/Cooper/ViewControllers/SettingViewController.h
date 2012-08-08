//
//  SettingViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-12.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SettingViewController : BaseTableViewController<UITextFieldDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
             setTitle:(NSString *)title 
             setImage:(NSString*)imageName;

@end
