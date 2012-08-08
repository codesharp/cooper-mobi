//
//  Cache.h
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#define LOCAL_CACHE_KEY @"cooper_login_user"

@interface Cache : NSObject

+ (NSMutableDictionary *)handler;

//用户preferences
+ (void)setCacheObject:(id)obj ForKey:(NSString *)key;
+ (id)getCacheByKey:(NSString *)key;
+ (void)removeCacheOfKey:(NSString *)key;

+ (void)saveToDisk;
+ (void)clean;

@end
