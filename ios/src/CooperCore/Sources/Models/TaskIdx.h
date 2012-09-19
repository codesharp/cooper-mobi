//
//  TaskIdx.h
//  CooperNative
//
//  Created by sunleepy on 12-9-19.
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
@property (nonatomic, retain) NSString * teamId;
@property (nonatomic, retain) NSString * projectId;
@property (nonatomic, retain) NSString * memberId;
@property (nonatomic, retain) NSString * tag;

@end
