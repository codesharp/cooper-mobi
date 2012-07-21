//
//  AccountService.h
//  Cooper
//
//  Created by sunleepy on 12-7-9.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import "NetworkManager.h"

@interface AccountService : NSObject

+ (void)arkLogin:(NSString *)domain username:(NSString *)username password:(NSString *)password delegate:(id)delegate;

+ (void)logout:(id)delegate;

@end
