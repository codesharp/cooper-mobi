//
//  NSString+decode.m
//  Cooper
//
//  Created by sunleepy on 12-7-4.
//  Copyright (c) 2012年 codesharp. All rights reserved.
//

#import "NSString+decode.h"

@implementation NSString (Additional)

- (NSString *)decode{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)encode{
    NSString *encUrl = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	int len = [encUrl length];
	const char *c;
	c = [encUrl UTF8String];
	NSString *ret = @"";
	for(int i = 0; i < len; i++) {
		switch (*c) {
			case '/':
				ret = [ret stringByAppendingString:@"%2F"];
				break;
			case '\'':
				ret = [ret stringByAppendingString:@"%27"];
				break;
			case ';':
				ret = [ret stringByAppendingString:@"%3B"];
				break;
			case '?':
				ret = [ret stringByAppendingString:@"%3F"];
				break;
			case ':':
				ret = [ret stringByAppendingString:@"%3A"];
				break;
			case '@':
				ret = [ret stringByAppendingString:@"%40"];
				break;
			case '&':
				ret = [ret stringByAppendingString:@"%26"];
				break;
			case '=':
				ret = [ret stringByAppendingString:@"%3D"];
				break;
			case '+':
				ret = [ret stringByAppendingString:@"%2B"];
				break;
			case '$':
				ret = [ret stringByAppendingString:@"%24"];
				break;
			case ',':
				ret = [ret stringByAppendingString:@"%2C"];
				break;
			case '[':
				ret = [ret stringByAppendingString:@"%5B"];
				break;
			case ']':
				ret = [ret stringByAppendingString:@"%5D"];
				break;
			case '#':
				ret = [ret stringByAppendingString:@"%23"];
				break;
			case '!':
				ret = [ret stringByAppendingString:@"%21"];
				break;
			case '(':
				ret = [ret stringByAppendingString:@"%28"];
				break;
			case ')':
				ret = [ret stringByAppendingString:@"%29"];
				break;
			case '*':
				ret = [ret stringByAppendingString:@"%2A"];
				break;
			default:
				ret = [ret stringByAppendingFormat:@"%c", *c];
		}
		c++;
	}
	
	return ret;
}

- (NSString *)lastSegment {
    NSRange range = [self rangeOfString:@"-"];
    int len = 0;
    NSString *str = self;
    while (1 == range.length) {
        //        NSLog(@"str %@  %@",str,NSStringFromRange(range));
        len = range.location + 1;
        str = [NSString stringWithFormat:@"%@",[str substringWithRange:NSMakeRange(len, [str length] - len)]];
        range = [str rangeOfString:@"-"];
    }
    return  str;
}

- (NSString *)toDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:MM:SS +0800"];
    int start =  [self rangeOfString:@"("].location+1;;
    int end = [self rangeOfString:@"+"].location;
    NSString *timeStr =  [self substringWithRange:NSMakeRange( start, (end - start))];
    NSTimeInterval time = [timeStr floatValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000.];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return [dateStr substringToIndex:10];
}


- (float)heightWithWidth:(float)width Font:(UIFont *)font {
	CGSize constraintSize = CGSizeMake(width,500);//MAXFLOAT
	CGSize labelSize = [self sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return labelSize.height ;
}

- (float)widthWithFont:(UIFont *)font {
    CGSize constraintSize = CGSizeMake(320,2000);
    CGSize labelsize = [self sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return labelsize.width;
}

@end
