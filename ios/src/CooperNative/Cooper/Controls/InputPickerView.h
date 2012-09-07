//
//  InputPickerView.h
//  CooperNative
//
//  Created by sunleepy on 12-9-5.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "InputPickerDelegate.h"

@interface InputPickerView : UIView
{
    UIView *inputAccessoryView;
    
    UITextField *textField;
}
@property (nonatomic, assign) id <InputPickerDelegate> delegate;
@end
