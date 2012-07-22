//
//  AES.h
//  XuanYJ
//
//  Created by Juxue C on 12-3-12.
//  Copyright (c) 2012年 etao. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>

@interface NSData (AESAdditions)
- (NSData*)AES256EncryptWithKey:(NSString*)key;
- (NSData*)AES256DecryptWithKey:(NSString*)key;
- (NSString*)stringWithHexBytes;

@end

