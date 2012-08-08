//
//  RootDao.h
//  Cooper
//
//  Created by sunleepy on 12-7-6.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

//#import "AppDelegate.h"

#import "CooperCore/ContextManager.h"

@class AppDelegate;

@interface RootDao : NSObject
{
    NSManagedObjectContext *context;
}
- (void) setContext;
- (void) commitData;
@end
