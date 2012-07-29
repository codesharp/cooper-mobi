//
//  AccountService.m
//  Cooper
//
//  Created by sunleepy on 12-7-9.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AccountService.h"

@implementation AccountService

+ (void)login:(NSString*)username password:(NSString*)password delegate:(id)delegate
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:username forKey:@"userName"];
    [data setObject:password forKey:@"password"];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers setObject:@"xmlhttp" forKey:@"X-Requested-With"];
    
    NSString* url = [[[Constant instance] path] stringByAppendingFormat:LOGIN_URL];
    NSLog(@"正在进行登录请求: %@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:nil addHeaders:headers];
}
+ (void) login:(NSString *)domain username:(NSString *)username password:(NSString *)password delegate:(id)delegate
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:@"login" forKey:@"state"];
    [data setObject:domain forKey:@"cbDomain"];
    [data setObject:username forKey:@"tbLoginName"];
    [data setObject:password forKey:@"tbPassword"];
    
    NSString* url = [[[Constant instance] path] stringByAppendingFormat:LOGIN_URL];
    NSLog(@"正在进行登录请求: %@", url);
    [NetworkManager doAsynchronousPostRequest:url Delegate:delegate data:data WithInfo:nil addHeaders:nil];
}

+ (void)logout:(id)delegate
{
    NSString* url = [[[Constant instance] path] stringByAppendingFormat:LOGOUT_URL];
    NSLog(@"正在进行注销请求: %@",url);
    [NetworkManager doAsynchronousGetRequest:url Delegate:delegate WithInfo:nil];
}

@end
