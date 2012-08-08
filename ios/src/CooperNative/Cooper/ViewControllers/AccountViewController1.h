//
//  AccountViewController.h
//  Cooper
//
//  Created by 磊 李 on 12-7-12.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "SimplePickerInputTableViewCell.h"
#import "BaseViewController.h"
#import "DomainLabel.h"

@interface AccountViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    MBProgressHUD *HUD;
    int requestType;
}

@property (retain, nonatomic) UITextField *textUsername;
@property (retain, nonatomic) UITextField *textPassword;
@property (retain, nonatomic) UITableView *loginTableView;

#ifndef CODESHARP_VERSION
@property (retain, nonatomic) DomainLabel *domainLabel;
#endif

@property (nonatomic,retain) UIView *accountView;

@end
