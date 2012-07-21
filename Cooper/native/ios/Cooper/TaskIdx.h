//
//  TaskIdx.h
//  Cooper
//
//  Created by sunleepy on 12-7-5.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TaskIdx : NSManagedObject

@property (nonatomic, retain) NSString * by;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * indexes;

@end
