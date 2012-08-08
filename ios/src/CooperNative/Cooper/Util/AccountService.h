//
//  AccountService.h
//  Cooper
//
//  Created by sunleepy on 12-7-9.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@interface AccountService : NSObject

+ (void)login:(NSString*)username password:(NSString*)password delegate:(id)delegate;

+ (void)login:(NSString *)domain username:(NSString *)username password:(NSString *)password delegate:(id)delegate;

+ (void)logout:(id)delegate;

@end
