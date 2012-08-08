//
//  ChangeLogDao.h
//  Cooper
//
//  Created by sunleepy on 12-7-9.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CooperCore/ChangeLog.h"
#import "RootDao.h"

@interface ChangeLogDao : RootDao
{
    NSString* tableName;
}
- (NSMutableArray*)getAllChangeLog:(NSString*)tasklistId;

- (void)insertChangeLog:(NSNumber*)type 
                 dataid:(NSString*)dataid 
                   name:(NSString*)name 
                  value:(NSString*)value 
             tasklistId:(NSString*)tasklistId;

- (void)updateIsSend:(ChangeLog *)changeLog;

- (void)updateAllToSend:(NSString*)tasklistId;

- (void)deleteChangLog:(ChangeLog*)changeLog;

@end
