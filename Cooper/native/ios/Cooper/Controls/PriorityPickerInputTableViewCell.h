//
//  PriorityPickerInputTableViewCell.h
//  Cooper
//
//  Created by Ping Li on 12-7-25.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "PickerInputTableViewCell.h"

@class PriorityPickerInputTableViewCell;

@protocol PriorityPickerInputTableViewCellDelegate <NSObject>
@optional
- (void)tableViewCell:(PriorityPickerInputTableViewCell *)cell didEndEditingWithValue:(NSString *)value;
@end

@interface PriorityPickerInputTableViewCell : PickerInputTableViewCell <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, assign) id <PriorityPickerInputTableViewCellDelegate> delegate;
@end
