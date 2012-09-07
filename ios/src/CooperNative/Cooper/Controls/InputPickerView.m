//
//  InputPickerView.m
//  CooperNative
//
//  Created by sunleepy on 12-9-5.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "InputPickerView.h"
#import "CustomButton.h"

@implementation InputPickerView

@synthesize delegate;

- (UIView *)inputAccessoryView {
    //[textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.3];
    if (!inputAccessoryView) {
        inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Tools screenMaxWidth], 40)];
        [inputAccessoryView setBackgroundColor:APP_BACKGROUNDCOLOR];
        //inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
        //inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [inputAccessoryView sizeToFit];
        CGRect frame = inputAccessoryView.frame;
        //frame.size.height = 44.0f;
        inputAccessoryView.frame = frame;
        
        textField = [[[UITextField alloc] init] autorelease];
        [textField setFrame:CGRectMake(5, 5, 250 + [Tools screenMaxWidth] - 320, 30)];
        [textField setBackgroundColor:[UIColor whiteColor]];
        [textField setPlaceholder:@"任务表名称"];
        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        //[textField setReturnKeyType:UIReturnKeyDone];
        [textField setFont:[UIFont systemFontOfSize:14]];
        [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textField addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        CustomButton *customButton = [[CustomButton alloc] initWithFrame:CGRectMake(260 + [Tools screenMaxWidth] - 320, 5, 55, 30) image:[UIImage imageNamed:@"btn_center.png"]];
        customButton.layer.cornerRadius = 6.0f;
        [customButton.layer setMasksToBounds:YES];
        [customButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [customButton setTitle:@"添加" forState:UIControlStateNormal];
        
        [inputAccessoryView addSubview:textField];
        [inputAccessoryView addSubview:customButton];
        
        [customButton release];
    }
    
    [self resignFirstResponder];
    [textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];     
    return inputAccessoryView;
}

- (void)cancelAction:(id)sender
{
    [self resignFirstResponder];
}

- (void)doneAction:(id)sender {
    if([textField.text length] == 0)
    {
        [Tools alert:@"请输入任务表名称"];
        return;
    }
    //TODO:发送评论
    [delegate send:textField.text];
    textField.text = @"";
    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];

//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        popoverController.popoverContentSize = pickerSize;
//        //TODO:...
//        [popoverController presentPopoverFromRect:self.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        // resign the current first responder
//        for (UIView *subview in self.superview.subviews) {
//            if ([subview isFirstResponder]) {
//                [subview resignFirstResponder];
//            }
//        }
//        return NO;
//    } else
//    {
//        [self.picker setNeedsLayout];
//    }
    
	return [super becomeFirstResponder];
}

- (void)deviceDidRotate:(NSNotification*)notification {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		// we should only get this call if the popover is visible
        //TODO:...
		//[popoverController presentPopoverFromRect:self.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

- (BOOL)resignFirstResponder {
	//[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	//UITableView *tableView = (UITableView *)self.superview;
	//[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
    
    [super resignFirstResponder];
    [textField resignFirstResponder];
    
    return YES;
}

//- (UIView *)inputView
//{
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//		return nil;
//	} else {
//		return self.picker;
//	}
//}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//	if (selected) {
//		[self becomeFirstResponder];
//	}
//}

- (BOOL)hasText {
    return YES;
}

- (void)insertText:(NSString *)theText {
}

- (void)deleteBackward {
}

- (void)dealloc{
    [super dealloc];
    [textField release];
}

@end
