//
//  TaskIdx.h
//  Cooper
//
//  Created by sunleepy on 12-8-1.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TaskIdx : NSManagedObject

@property (nonatomic, retain) NSString * accountId;
@property (nonatomic, retain) NSString * by;
@property (nonatomic, retain) NSString * indexes;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * tasklistId;

@end
