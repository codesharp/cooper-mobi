//
//  AssertHelper.h
//  CodesharpSDK
//
//  Created by sunleepy on 12-8-21.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssertHelper : NSObject
+ (void)isTrue:(BOOL)expr:(NSString*)error;
+ (void)log;
@end
