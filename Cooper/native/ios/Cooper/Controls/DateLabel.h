//
//  DateLabel.h
//  Cooper
//
//  Created by Ping Li on 12-7-26.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "CustomButton.h"

@class DateLabel;

@protocol DateLabelDelegate <NSObject>
@optional
- (void)tableViewCell:(DateLabel *)label didEndEditingWithDate:(NSDate *)value;
@end

@interface DateLabel : CustomButton<UIPopoverControllerDelegate>
{
    UIPopoverController *popoverController;
	UIToolbar *inputAccessoryView;
}
@property (retain, nonatomic) IBOutlet UILabel *dateField;

@property (nonatomic, strong) NSDate *dateValue;
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (strong) IBOutlet id<DateLabelDelegate> delegate;

- (void)setMaxDate:(NSDate *)max;
- (void)setMinDate:(NSDate *)min;
- (void)setMinuteInterval:(NSUInteger)value;
@end
