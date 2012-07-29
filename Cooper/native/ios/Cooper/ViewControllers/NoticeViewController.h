//
//  NoticeViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-30.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "BaseViewController.h"

@interface NoticeViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

{
    UISwitch *localPushSwitch;
}
@property (nonatomic,retain) UITableView *noticeTableView;  

@end
