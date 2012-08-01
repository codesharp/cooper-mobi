//
//  AliConstant.m
//  Cooper
//
//  Created by sunleepy on 12-8-1.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AliConstant.h"

@implementation AliConstant

@synthesize domain;

+ (id)instance 
{
	static id obj = nil;
	if(nil == obj) {
		obj = [[self alloc] init];
	}
	return obj;	
}

- (id)init 
{
	if ((self = [super init])) {
        domain = @"";
        return self;
	}
	return nil;
}

+ (void)loadFromCache 
{
    [[ConstantClass instance] setDomain:[Cache getCacheByKey:@"domain"]];
    [super loadFromCache];
}

+ (void)saveToCache 
{
    [Cache clean];
    [Cache setCacheObject:[[ConstantClass instance] domain] ForKey:@"domain"];
    [super saveToCache];
}

@end
