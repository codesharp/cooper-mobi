//
//  RootDao.m
//  Cooper
//
//  Created by sunleepy on 12-7-6.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "RootDao.h"

@implementation RootDao

- (void) setContext {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
}

- (void) commitData{
    NSError *error = nil;
    if(!([context save:&error]))
        NSLog(@"error:%@", [error description]);
}

//- (void)dealloc{
//    [super release];
//}
@end
