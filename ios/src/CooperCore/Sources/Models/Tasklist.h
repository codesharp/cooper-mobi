//
//  Tasklist.h
//  CooperNative
//
//  Created by sunleepy on 12-9-14.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tasklist : NSManagedObject

@property (nonatomic, retain) NSString * accountId;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSNumber * editable;
@property (nonatomic, retain) NSString * extensions;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * listType;
@property (nonatomic, retain) NSString * name;

@end
