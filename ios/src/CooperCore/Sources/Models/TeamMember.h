//
//  TeamMember.h
//  CooperNative
//
//  Created by sunleepy on 12-9-19.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TeamMember : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * teamId;

@end
