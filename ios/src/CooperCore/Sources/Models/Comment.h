//
//  Comment.h
//  CooperNative
//
//  Created by sunleepy on 12-9-19.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSString * creatorId;
@property (nonatomic, retain) NSString * taskId;

@end
