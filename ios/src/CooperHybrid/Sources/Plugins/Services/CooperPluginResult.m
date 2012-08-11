//
//  CooperPluginResult.m
//  CooperHybrid
//
//  Created by sunleepy on 12-8-11.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CooperPluginResult.h"

@implementation CooperPluginResult

-(NSString*) toJSONString
{
    NSString* resultString = [[NSDictionary dictionaryWithObjectsAndKeys:
                               self.status, @"status",
                               self.message ? self.message : [NSNull null], @"message",
                               self.keepCallback, @"keepCallback",
                               nil] JSONRepresentation];
    
	return resultString;
}



@end
