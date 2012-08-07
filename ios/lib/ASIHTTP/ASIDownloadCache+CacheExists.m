//
//  ASIDownloadCache+CacheExists.m
//  snstaoban
//
//  Created by Yuliang.Wu on 12/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ASIDownloadCache+CacheExists.h"
#import "ASIHTTPRequest.h"

#import <CommonCrypto/CommonHMAC.h>

@implementation ASIDownloadCache (CacheExists)

- (BOOL)cacheExistsForRequest:(ASIHTTPRequest *)request {
    NSString *path = [self pathToCachedResponseDataForURL:[request url]];
    BOOL ret = [[[[NSFileManager alloc] init] autorelease] fileExistsAtPath:path];
    NSLog(@"ASIHTTPRequest hit cache: %@", ret ? @"YES" : @"NO");
    return ret;
}

@end
