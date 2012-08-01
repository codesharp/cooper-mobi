//
//  PriorityButton.h
//  Cooper
//
//  Created by Ping Li on 12-7-26.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CustomButton.h"

@class PriorityButton;

@protocol PriorityButtonDelegate <NSObject>
@optional
- (void)tableViewCell:(PriorityButton *)button didEndEditingWithValue:(NSString *)value;
@end

@interface PriorityButton : CustomButton<UIKeyInput, UIPopoverControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    // For iPad
	UIPopoverController *popoverController;
    UIToolbar *inputAccessoryView;
}

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, assign) id <PriorityButtonDelegate> delegate;
@end
