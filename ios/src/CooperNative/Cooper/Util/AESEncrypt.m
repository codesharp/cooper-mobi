//
//  AESEncrypt.m
//  XuanYJ
//
//  Created by Juxue C on 12-3-12.
//  Copyright (c) 2012年 etao. All rights reserved.
//

#import "AESEncrypt.h"
#import "AES.h"

@implementation AESEncrypt

+ (NSString *) encryptString:(NSString*)message withKey:(NSString*)key {
	NSString *encryptedString = [[NSString alloc] initWithString:@""];
	
	int msgLen = [message length];
    
	for (int i=0; MAXLENGTH*i<msgLen; i++) {
		int begin = MAXLENGTH * i;
		int len = ((begin + MAXLENGTH) <= msgLen) ? MAXLENGTH : msgLen - begin;
		encryptedString = [encryptedString stringByAppendingString:[[[[message substringWithRange:NSMakeRange(begin, len)]
                                                                      dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:key]
                                                                    stringWithHexBytes]];
	}
	return encryptedString;
}

@end
