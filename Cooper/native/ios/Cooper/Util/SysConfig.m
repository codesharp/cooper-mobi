//
//  SysConfig.m
//  Cooper
//
//  Created by Ping Li on 12-7-23.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "SysConfig.h"

@implementation SysConfig

@synthesize keyValue;

+ (id)instance {
	static id obj = nil;
	if(nil == obj) {
		obj = [[self alloc] init];
	}
	return obj;	
}

- (id)init
{
    if ((self = [super init])) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
        keyValue = [[NSDictionary dictionary] initWithContentsOfFile:plistPath]; 
        return self;
	}
	return nil;
}

@end
