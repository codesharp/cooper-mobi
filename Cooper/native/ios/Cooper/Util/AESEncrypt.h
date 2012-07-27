//
//  AESEncrypt.h
//  XuanYJ
//
//  Created by Juxue C on 12-3-12.
//  Copyright (c) 2012年 etao. All rights reserved.
//


@interface AESEncrypt : NSObject

+ (NSString *) encryptString:(NSString*)message withKey:(NSString*)key;

@end
