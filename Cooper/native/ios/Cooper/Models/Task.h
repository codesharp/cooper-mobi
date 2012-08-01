//
//  Task.h
//  Cooper
//
//  Created by sunleepy on 12-8-1.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * accountId;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * editable;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * isPublic;
@property (nonatomic, retain) NSDate * lastUpdateDate;
@property (nonatomic, retain) NSString * priority;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * tasklistId;

@end
