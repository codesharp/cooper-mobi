//
//  ChangeLogDao.h
//  Cooper
//
//  Created by sunleepy on 12-7-9.
//  Copyright (c) 2012年 alibaba. All rights reserved.
//

#import "RootDao.h"
#import "ChangeLog.h"

@interface ChangeLogDao : RootDao

- (NSMutableArray*)getAllChangeLog;

- (void)insertChangeLog:(NSNumber*)type dataid:(NSString*)dataid name:(NSString*)name value:(NSString*)value;

- (void)updateIsSend:(ChangeLog *)changeLog;

- (void)updateAllToSend;

- (void)deleteChangLog:(ChangeLog*)changeLog;

@end
