//
//  SysConfig.h
//  Cooper
//
//  Created by Ping Li on 12-7-23.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SysConfig : NSObject

@property (nonatomic, retain) NSDictionary *keyValue;

+ (id)instance;

@end
