//
//  AccountViewController.h
//  Cooper
//
//  Created by 磊 李 on 12-7-12.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "SimplePickerInputTableViewCell.h"

@interface AccountViewController : UITableViewController<SimplePickerInputTableViewCellDelegate>
{
    MBProgressHUD *HUD;
    int requestType;
}
@end
