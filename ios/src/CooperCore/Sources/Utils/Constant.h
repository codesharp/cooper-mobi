//
//  Constant.h
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "CodesharpSDK/Cache.h"

@interface Constant : NSObject

@property (nonatomic,retain) NSString *sortHasChanged;
@property (nonatomic,retain) NSString *domain;
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *token;
@property (nonatomic,assign) NSString *loginType;
@property (nonatomic,retain) NSString *rootPath;
@property (nonatomic,retain) NSMutableArray *recentlyIds;
@property (nonatomic,retain) NSMutableArray *recentlyTeamIds;
@property (nonatomic,assign) bool isLocalPush;
@property (nonatomic,retain) NSString *tempCreateTasklistId;
@property (nonatomic,retain) NSString *tempCreateTasklistName;

+ (id)instance;

+ (void)saveToCache;
+ (void)loadFromCache;
+ (void)savePathToCache;
+ (void)saveSortHasChangedToCache;
//+ (void)saveRecentlyIdsToCache;
//+ (void)saveIsLocalPushToCache;

@end
