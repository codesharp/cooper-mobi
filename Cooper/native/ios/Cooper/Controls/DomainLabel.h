//
//  DomainLabel.h
//  Cooper
//
//  Created by Ping Li on 12-7-25.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//
@class DomainLabel;

@protocol DomainLabelDelegate <NSObject>
@optional
- (void)tableViewCell:(DomainLabel *)label didEndEditingWithValue:(NSString *)value;
@end

@interface DomainLabel : UILabel<UIKeyInput, UIPopoverControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    // For iPad
	UIPopoverController *popoverController;
    UIToolbar *inputAccessoryView;
}

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, assign) id <DomainLabelDelegate> delegate;

@end
