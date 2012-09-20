//
//  TeamTaskFilterLabel.h
//  CooperNative
//
//  Created by sunleepy on 12-9-20.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@class TeamTaskFilterLabel;

@protocol TeamTaskFilterLabelDelegate
@optional
- (void)tableViewCell:(TeamTaskFilterLabel *)label didEndEditingWithValue:(NSString *)value;
- (void)doneFilterCallback:(TeamTaskFilterLabel*)label withValue:(NSString*)value;
@end

@interface TeamTaskFilterLabel : UILabel<UIKeyInput, UIPopoverControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    //For iPad
    UIPopoverController *popoverController;
    UIToolbar *inputAccessoryView;
}

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) NSString *currentValue;
@property (nonatomic, assign) id <TeamTaskFilterLabelDelegate> delegate;

@end
