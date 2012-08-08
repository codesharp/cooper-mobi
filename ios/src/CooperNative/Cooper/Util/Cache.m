//
//  Cache.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "Cache.h"

@implementation Cache

+ (NSMutableDictionary *)handler {
	static NSMutableDictionary *cacheHandler = nil;
	if (nil == cacheHandler) {
		NSUserDefaults *handler = [NSUserDefaults standardUserDefaults];
		if (nil != [handler objectForKey:LOCAL_CACHE_KEY]) {
			cacheHandler = [[NSMutableDictionary alloc] initWithDictionary:[handler objectForKey:LOCAL_CACHE_KEY]];
		}
		else {
			cacheHandler = [[NSMutableDictionary alloc] init];
		}
	}
	return cacheHandler;
}

+ (void)setCacheObject:(id)obj ForKey:(NSString *)key {
	if (nil != obj && nil != key && 0 < [key length]) {
		[Cache removeCacheOfKey:key];
		[[Cache handler] setObject:obj forKey:key];
	}
}

+ (id)getCacheByKey:(NSString *)key {
	NSUserDefaults *handler = [NSUserDefaults standardUserDefaults];
	if (nil != key && 0 < [key length] && nil != [[Cache handler] objectForKey:key]) {
		return [[Cache handler] objectForKey:key];
	}
	else if (nil != key && 0 < [key length] && nil != [handler objectForKey:key]) {
		return [NSKeyedUnarchiver unarchiveObjectWithData:[handler objectForKey:key]];
	}
	
	return nil;
}

+ (void)removeCacheOfKey:(NSString *)key {
	[[Cache handler] removeObjectForKey:key];
}

+ (void)saveToDisk {
	NSUserDefaults *handler = [NSUserDefaults standardUserDefaults];
	if (0 < [[Cache handler] count]) {
		[handler setObject:[Cache handler] forKey:LOCAL_CACHE_KEY];
	}
	[handler synchronize];
}

+ (void)clean {
	for (NSString *key in [[Cache handler] allKeys]) {
		[Cache removeCacheOfKey:key];
	}
}

@end
