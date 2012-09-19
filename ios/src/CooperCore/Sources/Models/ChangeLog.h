//
//  ChangeLog.h
//  CooperNative
//
//  Created by sunleepy on 12-9-19.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ChangeLog : NSManagedObject

@property (nonatomic, retain) NSString * accountId;
@property (nonatomic, retain) NSNumber * changeType;
@property (nonatomic, retain) NSString * dataId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * tasklistId;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * teamId;
@property (nonatomic, retain) NSString * projectId;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSString * memberId;

@end
