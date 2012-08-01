//
//  Constant.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "Constant.h"

@implementation Constant

//@synthesize domain;
@synthesize username;
@synthesize password;
@synthesize token;
@synthesize isSaveUser;
@synthesize rootPath;
@synthesize recentlyIds;
@synthesize isLocalPush;

+ (id)instance {
	static id obj = nil;
	if(nil == obj) {
		obj = [[self alloc] init];
	}
	return obj;	
}

- (id)init {
	if ((self = [super init])) {
//        domain = @"";
        username = @"";
        password = @"";
        token = @"";
        isSaveUser = NO;
        isLocalPush = NO;
        rootPath = @"";
        recentlyIds = nil;
        return self;
	}
	return nil;
}

+ (void)loadFromCache {
    [[ConstantClass instance] setIsSaveUser:[[Cache getCacheByKey:@"isSaveUser"] intValue]];
    [[ConstantClass instance] setIsLocalPush:[[Cache getCacheByKey:@"isLocalPush"] intValue]];
//    [[ConstantClass instance] setDomain:[Cache getCacheByKey:@"domain"]];
    [[ConstantClass instance] setUsername:[Cache getCacheByKey:@"username"]];
    [[ConstantClass instance] setRootPath:[Cache getCacheByKey:@"rootPath"]];
    
    id recentlyIds = [Cache getCacheByKey:@"recentlyIds"];
    if([Cache getCacheByKey:@"recentlyIds"] != nil)
    {
        [[ConstantClass instance] setRecentlyIds:recentlyIds];
    }
    
    NSLog(@"Recently Tasklist count: %d", [[[ConstantClass instance] recentlyIds] count]);
}

+ (void)saveToCache {
    [Cache clean];
    [Cache setCacheObject:[NSNumber numberWithFloat:[[ConstantClass instance] isSaveUser]] ForKey:@"isSaveUser"];
//    [Cache setCacheObject:[[ConstantClass instance] domain] ForKey:@"domain"];
    [Cache setCacheObject:[[ConstantClass instance] username] ForKey:@"username"];
    //[Cache setCacheObject:[[ConstantClass instance] password] ForKey:@"password"];
    [Cache setCacheObject:[[ConstantClass instance] rootPath] ForKey:@"rootPath"];
    [Cache saveToDisk];
}

+ (void)savePathToCache
{
    [Cache setCacheObject:[[ConstantClass instance] rootPath] ForKey:@"rootPath"];
    [Cache saveToDisk];
}

+ (void)saveRecentlyIdsToCache
{
    [Cache setCacheObject:[[ConstantClass instance] recentlyIds] ForKey:@"recentlyIds"];
    [Cache saveToDisk];
}

+ (void)saveIsLocalPushToCache
{
    [Cache setCacheObject:[NSNumber numberWithFloat:[[ConstantClass instance] isLocalPush]] ForKey:@"isLocalPush"];
    [Cache saveToDisk];
}

@end
