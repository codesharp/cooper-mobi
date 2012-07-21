//
//  Task.h
//  Cooper
//
//  Created by sunleepy on 12-7-5.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSNumber * accountId;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * isPublic;
@property (nonatomic, retain) NSString * priority;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSDate * lastUpdateDate;

@end
