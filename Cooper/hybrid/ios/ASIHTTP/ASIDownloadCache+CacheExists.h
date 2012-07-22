//
//  ASIDownloadCache+CacheExists.h
//  snstaoban
//
//  Created by Yuliang.Wu on 12/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ASIDownloadCache.h"


@interface ASIDownloadCache (CacheExists)

- (BOOL)cacheExistsForRequest:(ASIHTTPRequest *)request;

@end
