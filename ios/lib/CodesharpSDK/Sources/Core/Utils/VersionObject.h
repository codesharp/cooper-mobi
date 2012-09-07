//
//  VersionObject.h
//  CodesharpSDK
//
//  Created by sunleepy on 12-8-21.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionObject : NSObject

@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSString *shortVersion;
@property (nonatomic, assign) NSString *version;

+ (VersionObject*)getVersionObject:(NSDictionary*)dictionary;

@end
