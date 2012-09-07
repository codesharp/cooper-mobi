//
//  AssertHelper.m
//  CodesharpSDK
//
//  Created by sunleepy on 12-8-21.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "AssertHelper.h"

@implementation AssertHelper

+ (void)isTrue:(BOOL)expr:(NSString*)error
{
    if(!expr)
    {
        NSException *exception = [NSException exceptionWithName:@"" reason:error userInfo:nil];
        @throw exception;
    }
}

+ (void)log{
    NSLog(@"hi 3");
}

@end
