//
//  CommentViewController.h
//  Cooper
//
//  Created by sunleepy on 12-7-5.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *commentView;

@end
