//
//  AccountService.h
//  Cooper
//
//  Created by sunleepy on 12-7-9.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@interface AccountService : NSObject

+ (void)login:(NSString*)username 
     password:(NSString*)password 
      context:(NSMutableDictionary*)context
     delegate:(id)delegate;

+ (void)login:(NSString *)domain 
     username:(NSString *)username 
     password:(NSString *)password 
      context:(NSMutableDictionary*)context 
     delegate:(id)delegate;
+ (void)googleLogin:(NSString*)refreshToken
            context:(NSMutableDictionary*)context
           delegate:(id)delegate;
+ (void)googleLogin:(NSString *)error
               code:(NSString*)code
              state:(NSString*)state
               mobi:(NSString*)mobi
               joke:(NSString*)joke
            context:(NSMutableDictionary*)context 
           delegate:(id)delegate;
+ (void)logout:(NSMutableDictionary*)context 
      delegate:(id)delegate;

@end
