//
//  Tools.m
//  Cooper
//
//  Created by sunleepy on 12-7-8.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (NSString*) NSNumberToString:(NSNumber*)input
{
    return [NSString stringWithFormat:@"%d", [input boolValue]];
}

+ (NSNumber*) BOOLToNSNumber:(BOOL)input
{
    return [NSNumber numberWithBool:input];
}

+ (NSString*) NSDateToNSString:(NSDate*)input
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.timeStyle = NSDateFormatterNoStyle;
    //dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    [dateFormatter setDateFormat:@"yyyy-M-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter stringFromDate:input];
    
    [dateFormatter release];
    
    return date;
}

+ (NSString*) ShortNSDateToNSString:(NSDate*)input
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-M-dd"];
    
    NSDate *date = [dateFormatter stringFromDate:input];
    
    [dateFormatter release];
    
    return date;
}

+ (NSDate*) NSStringToNSDate:(NSString*)input
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-M-dd HH:mm:ss"];
    
    NSData *date = [dateFormatter dateFromString:input];
    
    [dateFormatter release];
    
    return date;
}

+ (NSDate*) NSStringToShortNSDate:(NSString*)input
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-M-dd"];
    
    NSData *date = [dateFormatter dateFromString:input];
    
    [dateFormatter release];
    
    return date;
}

+ (NSString*) BOOLToNSString:(BOOL)value
{
    return [NSString stringWithFormat:@"%d", value];
}

+ (void)alert:(NSString *)title 
{
    [[[[UIAlertView alloc] initWithTitle:title
                                message:nil  
                               delegate:nil 
                      cancelButtonTitle:@"ok" 
                      otherButtonTitles:nil] autorelease] show];
}

+ (MBProgressHUD*)process:(NSString*)title view:(UIView*)view
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if ([title length]) {
        HUD.labelText = title;
    }
    return HUD;
}

+ (void)msg:(NSString*)title HUD:(MBProgressHUD*)HUD
{
    [HUD show:YES];
    HUD.labelText = title;
    [HUD hide:YES afterDelay:1];
}

+ (void)close:(MBProgressHUD*)HUD
{
    [HUD hide:YES];
}

+ (void)failed:(MBProgressHUD*)HUD
{
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.labelText = @"请求失败";
    HUD.mode = MBProgressHUDModeCustomView;
	[HUD hide:YES afterDelay:0.3];
}

+ (NSString*) stringWithUUID {
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}

@end
