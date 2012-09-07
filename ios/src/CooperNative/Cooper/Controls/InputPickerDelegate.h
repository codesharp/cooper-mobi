//
//  InputPickerDelegate.h
//  CooperNative
//
//  Created by sunleepy on 12-9-5.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@protocol InputPickerDelegate <UITextFieldDelegate>
@optional
- (void)send:(NSString *)value;
@end