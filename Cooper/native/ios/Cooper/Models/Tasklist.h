//
//  Tasklist.h
//  Cooper
//
//  Created by sunleepy on 12-7-29.
//  Copyright (c) 2012年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tasklist : NSManagedObject

@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSString * extensions;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * listType;
@property (nonatomic, retain) NSString * name;

@end
