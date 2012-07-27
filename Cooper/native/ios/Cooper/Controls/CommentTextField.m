//
//  CommentTextField.m
//  Cooper
//
//  Created by Ping Li on 12-7-26.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import "CommentTextField.h"

@implementation CommentTextField

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{ 
    self = [super initWithFrame:frame];
    if (self) {
		//[self initalizeInputView];
        NSLog(@"initInputVlew");
    }
    return self;
}

- (UIView *)inputAccessoryView {
    [addCommentTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.3];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return nil;
	} else {
		if (!inputAccessoryView) {
			inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
            [inputAccessoryView setBackgroundColor:APP_BACKGROUNDCOLOR];
			//inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
			//inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
			[inputAccessoryView sizeToFit];
			CGRect frame = inputAccessoryView.frame;
			//frame.size.height = 44.0f;
			inputAccessoryView.frame = frame;
            
            addCommentTextField = [[[UITextField alloc] init] autorelease];
            [addCommentTextField setFrame:CGRectMake(5, 5, 250, 30)];
            [addCommentTextField setBackgroundColor:[UIColor whiteColor]];
            [addCommentTextField setPlaceholder:@"发表评论"];
            [addCommentTextField setReturnKeyType:UIReturnKeyDone];
            [addCommentTextField setFont:[UIFont systemFontOfSize:14]];
            [addCommentTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [addCommentTextField addTarget:self action:@selector(addCommentAction:) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            CustomButton *customButton = [[CustomButton alloc] initWithFrame:CGRectMake(260, 5, 55, 30) image:[UIImage imageNamed:@"btn_center.png"]];
            customButton.layer.cornerRadius = 6.0f;
            [customButton.layer setMasksToBounds:YES];
            [customButton addTarget:self action:@selector(addCommentAction:) forControlEvents:UIControlEventTouchUpInside];
            [customButton setTitle:@"发送" forState:UIControlStateNormal];
            
            [inputAccessoryView addSubview:addCommentTextField];
            [inputAccessoryView addSubview:customButton];
            
            [customButton release]; 
		}
        
        [self resignFirstResponder];
        
        [addCommentTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.3];
       
        
		return inputAccessoryView;
	}
}

- (void)addCommentAction:(id)sender {
    //TODO:发送评论
    [delegate sendComment:addCommentTextField.text];
    addCommentTextField.text = @"";
    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
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
//    } else {
//        [self.picker setNeedsLayout];
//    }
	return [super becomeFirstResponder];
}

- (void)deviceDidRotate:(NSNotification*)notification {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		// we should only get this call if the popover is visible
        //TODO:...
		[popoverController presentPopoverFromRect:self.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

- (BOOL)resignFirstResponder {
	//[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	//UITableView *tableView = (UITableView *)self.superview;
	//[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
    [addCommentTextField resignFirstResponder];
	 [super resignFirstResponder];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	if (selected) {
		[self becomeFirstResponder];
	}
}

- (BOOL)hasText {
    return YES;
}

- (void)insertText:(NSString *)theText {
}

- (void)deleteBackward {
}

- (void)dealloc{
    [super dealloc];
    [addCommentTextField release];
}

@end
