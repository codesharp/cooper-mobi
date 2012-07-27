//
//  Constant.h
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@interface Constant : NSObject

@property (nonatomic,retain) NSString *domain;
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *token;
@property (nonatomic,assign) bool isSaveUser;
@property (nonatomic,retain) NSString *path;

+ (id)instance;

+ (void)saveToCache;
+ (void)loadFromCache;
+ (void)savePathToCache;

@end
