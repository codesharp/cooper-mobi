//
//  EndDateCell.h
//  Cooper
//
//  Created by sunleepy on 12-7-2.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DateInputTableViewCell;

@protocol DateInputTableViewCellDelegate <NSObject>
@optional
- (void)tableViewCell:(DateInputTableViewCell *)cell didEndEditingWithDate:(NSDate *)value;
@end

@interface EndDateCell : UITableViewCell<UIPopoverControllerDelegate>
{
    UIPopoverController *popoverController;
	UIToolbar *inputAccessoryView;
}
@property (retain, nonatomic) IBOutlet UILabel *dateField;

@property (nonatomic, strong) NSDate *dateValue;
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (strong) IBOutlet id<DateInputTableViewCellDelegate> delegate;

- (void)setMaxDate:(NSDate *)max;
- (void)setMinDate:(NSDate *)min;
- (void)setMinuteInterval:(NSUInteger)value;

@end
