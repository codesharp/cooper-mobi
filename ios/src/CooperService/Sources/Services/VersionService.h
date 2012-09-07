//
//  VersionService.h
//  CooperService
//
//  Created by sunleepy on 12-8-21.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@interface VersionService : NSObject

+ (void)getCurrentAppVersion:(NSMutableDictionary*)context delegate:(id)delegate;
@end
