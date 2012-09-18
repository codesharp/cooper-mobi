//
//  TeamService.m
//  CooperService
//
//  Created by sunleepy on 12-9-14.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "TeamService.h"

@implementation TeamService

- (void)getTeams:(NSMutableDictionary *)context
        delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:GETTEAMS_URL];
    NSLog(@"getTeams服务路径: %@", url);
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request getAsync:url params:nil headers:nil context:context delegate:delegate];
    [request release];
}
- (void)syncTasks:(NSString*)teamId
        projectId:(NSString*)projectId
         memberId:(NSString*)memberId
              tag:(NSString*)tag
          context:(NSMutableDictionary*)context
         delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:TEAMTASK_SYNC_URL];
    NSLog(@"syncTasks服务路径: %@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:teamId forKey:@"teamId"];
    if (projectId != nil)
    {
        [params setObject:projectId forKey:@"projectId"];
    }
    if (memberId != nil)
    {
        [params setObject:memberId forKey:@"memberId"];
    }
    if (tag != nil)
    {
        [params setObject:tag forKey:@"tag"];
    }
    
    
}
- (void)getTasks:(NSString*)teamId
       projectId:(NSString*)projectId
        memberId:(NSString*)memberId
             tag:(NSString*)tag
         context:(NSMutableDictionary*)context
        delegate:(id)delegate
{
    NSString *url = [[[ConstantClass instance] rootPath] stringByAppendingFormat:TeamTask_GETINCOMPLETEDBYPRIORITY_URL];
    NSLog(@"getIncompletedByPriority服务路径: %@", url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:teamId forKey:@"teamId"];
    if (projectId != nil)
    {
        [params setObject:projectId forKey:@"projectId"];
    }
    if (memberId != nil)
    {
        [params setObject:memberId forKey:@"memberId"];
    }
    if (tag != nil)
    {
        [params setObject:tag forKey:@"tag"];
    }
    
    HttpWebRequest *request = [[HttpWebRequest alloc] init];
    [request postAsync:url params:params headers:nil context:context delegate:delegate];
    [request release];
}

@end
