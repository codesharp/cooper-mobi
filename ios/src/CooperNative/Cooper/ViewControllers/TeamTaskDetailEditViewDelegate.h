//
//  TeamTaskDetailEditViewDelegate.h
//  CooperNative
//
//  Created by sunleepy on 12-9-21.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@protocol TeamTaskDetailEditViewDelegate

- (void)modifyAssignee:(NSString*)assignee;
- (void)modifyProjects:(NSString*)projects;
- (void)modifyTags:(NSString*)tags;

@end
