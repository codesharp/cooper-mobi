//
//  AccountViewController.h
//  Cooper
//
//  Created by 磊 李 on 12-7-12.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "SimplePickerInputTableViewCell.h"
#import "BaseTableViewController.h"
#import "DomainLabel.h"

@interface AccountViewController : BaseTableViewController<SimplePickerInputTableViewCellDelegate>
{
    MBProgressHUD *HUD;
    int requestType;
}

#ifndef CODESHARP_VERSION
@property (retain, nonatomic) DomainLabel *domainLabel;
#endif

@end
