//
//  AliConstant.h
//  Cooper
//
//  Created by sunleepy on 12-8-1.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "Constant.h"

@interface AliConstant : Constant

@property (nonatomic,retain) NSString *domain;

+ (id)instance;
+ (void)loadFromCache;
+ (void)saveToCache;

@end
