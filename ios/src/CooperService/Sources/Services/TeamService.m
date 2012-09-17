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

@end
