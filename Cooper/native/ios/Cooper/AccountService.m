//
//  AccountService.m
//  Cooper
//
//  Created by sunleepy on 12-7-9.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AccountService.h"

@implementation AccountService

+ (void) arkLogin:(NSString *)domain username:(NSString *)username password:(NSString *)password delegate:(id)delegate
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:@"login" forKey:@"state"];
    [data setObject:domain forKey:@"cbDomain"];
    [data setObject:username forKey:@"tbLoginName"];
    [data setObject:password forKey:@"tbPassword"];
    
    NSString* url = [[[Constant instance] path] stringByAppendingFormat:LOGIN_URL];
    NSLog(@"loginurl:%@",url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:nil];
}

+ (void)logout:(id)delegate
{
    NSString* url = [[[Constant instance] path] stringByAppendingFormat:LOGOUT_URL];
    NSLog(@"logouturl:%@",url);
    [NetworkManager doAsynchronousGetRequest:url Delegate:delegate WithInfo:nil];
}

@end
