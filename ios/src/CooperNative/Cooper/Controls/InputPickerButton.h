//
//  InputPickerButton.h
//  Cooper
//
//  Created by sunleepy on 12-7-31.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "InputPickerDelegate.h"

@interface InputPickerButton : UIButton
{
    UIView *inputAccessoryView;
    
    UITextField *textField;
}
//@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, assign) id <InputPickerDelegate> delegate;

@end
