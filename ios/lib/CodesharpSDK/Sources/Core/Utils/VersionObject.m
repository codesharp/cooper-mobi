//
//  VersionObject.m
//  CodesharpSDK
//
//  Created by sunleepy on 12-8-21.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "VersionObject.h"

@implementation VersionObject

@synthesize name;
@synthesize shortVersion;
@synthesize version;

+ (VersionObject*)getVersionObject:(NSDictionary *)dictionary
{
    VersionObject *versionObject = [[VersionObject alloc] init];
    versionObject.version = [dictionary objectForKey:@"CFBundleVersion"];
    versionObject.shortVersion = [dictionary objectForKey:@"CFBundleShortVersionString"];
    versionObject.name = [dictionary objectForKey:@"CFBundleDisplayName"];
    return [versionObject autorelease];
}

@end
