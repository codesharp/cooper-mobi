//
//  Task.h
//  CooperNative
//
//  Created by sunleepy on 12-9-14.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * accountId;
@property (nonatomic, retain) NSString * assigneeId;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * createMemberId;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * editable;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * isPublic;
@property (nonatomic, retain) NSDate * lastUpdateDate;
@property (nonatomic, retain) NSString * priority;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSString * tasklistId;
@property (nonatomic, retain) NSString * taskType;
@property (nonatomic, retain) NSString * teamId;

@end
