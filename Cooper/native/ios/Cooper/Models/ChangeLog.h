//
//  ChangeLog.h
//  Cooper
//
//  Created by sunleepy on 12-7-29.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ChangeLog : NSManagedObject

@property (nonatomic, retain) NSNumber * changeType;
@property (nonatomic, retain) NSString * dataid;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isSend;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * tasklistId;

@end
