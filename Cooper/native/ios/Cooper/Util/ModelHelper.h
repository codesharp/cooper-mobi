//
//  ModelHelper.h
//  Cooper
//
//  Created by sunleepy on 12-7-5.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//


#import <CoreData/CoreData.h>

@interface ModelHelper : NSObject

+ (id) create:(NSString*)modelName context:(NSManagedObjectContext*)managedObjectContext;

@end
