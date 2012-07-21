//
//  ModelHelper.m
//  Cooper
//
//  Created by sunleepy on 12-7-5.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import "ModelHelper.h"

@implementation ModelHelper

+ (id) create:(NSString*)modelName context:(NSManagedObjectContext*)managedObjectContext
{
    return [NSEntityDescription insertNewObjectForEntityForName:modelName inManagedObjectContext:managedObjectContext]; 
}

@end
