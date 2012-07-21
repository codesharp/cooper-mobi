//
//  NSString+decode.h
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

@interface NSString (decode)

- (NSString *)decode;

- (NSString *)encode;

- (NSString *)lastSegment;

- (NSString *)toDateString;

- (float)heightWithWidth:(float)width Font:(UIFont *)font;

- (float)widthWithFont:(UIFont *)font;

@end
