//
//  Constant.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "Constant.h"
#import "Cache.h"

@implementation Constant

@synthesize domain;
@synthesize username;
@synthesize password;
@synthesize token;
@synthesize isSaveUser;
@synthesize path;

+ (id)instance {
	static id obj = nil;
	if(nil == obj) {
		obj = [[self alloc] init];
	}
	return obj;	
}

- (id)init {
	if ((self = [super init])) {
        domain = @"";
        username = @"";
        password = @"";
        token = @"";
        isSaveUser = NO;
        path = @"";
        return self;
	}
	return nil;
}

+ (void)saveToCache {
    [Cache clean];
    [Cache setCacheObject:[NSNumber numberWithFloat:[[Constant instance] isSaveUser]] ForKey:@"isSaveUser"];
    [Cache setCacheObject:[[Constant instance] domain] ForKey:@"domain"];
    [Cache setCacheObject:[[Constant instance] username] ForKey:@"username"];
    //[Cache setCacheObject:[[Constant instance] password] ForKey:@"password"];
    [Cache setCacheObject:[[Constant instance] path] ForKey:@"path"];
    [Cache saveToDisk];
}

+ (void)loadFromCache {
    [[Constant instance] setIsSaveUser:[[Cache getCacheByKey:@"isSaveUser"] intValue]];
    [[Constant instance] setDomain:[Cache getCacheByKey:@"domain"]];
    [[Constant instance] setUsername:[Cache getCacheByKey:@"username"]];
    //[[Constant instance] setPassword:[Cache getCacheByKey:@"password"]];
    [[Constant instance] setPath:[Cache getCacheByKey:@"path"]];
}

+ (void)savePathToCache
{
    [Cache setCacheObject:[[Constant instance] path] ForKey:@"path"];
    [Cache saveToDisk];
}

@end
