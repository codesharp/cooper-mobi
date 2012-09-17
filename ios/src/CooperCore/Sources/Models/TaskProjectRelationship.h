//
//  TaskProjectRelationship.h
//  CooperNative
//
//  Created by sunleepy on 12-9-14.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TaskProjectRelationship : NSManagedObject

@property (nonatomic, retain) NSString * projectId;
@property (nonatomic, retain) NSString * taskId;

@end
