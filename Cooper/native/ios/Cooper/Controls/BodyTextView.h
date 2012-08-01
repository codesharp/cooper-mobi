//
//  BodyTextView.h
//  Cooper
//
//  Created by sunleepy on 12-7-31.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BodyTextView : UITextView
{
    UIToolbar *inputAccessoryView;
    
    UITextField *textField;
}
@property (nonatomic, strong) UIPickerView *picker;

@end
