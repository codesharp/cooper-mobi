//
//  Tools.h
//  Cooper
//
//  Created by sunleepy on 12-7-8.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "MBProgressHUD.h"

@interface Tools : NSObject

+ (NSString*) NSNumberToString:(NSNumber*)input;

+ (NSNumber*) BOOLToNSNumber:(BOOL)input;

+ (NSString*) NSDateToNSString:(NSDate*)input;

+ (NSString*) ShortNSDateToNSString:(NSDate*)input;

+ (NSDate*) NSStringToNSDate:(NSString*)input;

+ (NSDate*) NSStringToShortNSDate:(NSString*)input;

+ (NSString*) BOOLToNSString:(BOOL)value;

+ (void)alert:(NSString *)title;

+ (MBProgressHUD*)process:(NSString*)title view:(UIView*)view;

+ (void)msg:(NSString*)title HUD:(MBProgressHUD*)HUD;

+ (void)close:(MBProgressHUD*)HUD;

+ (void)failed:(MBProgressHUD*)HUD;

@end
