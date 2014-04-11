//
//  XXStringUtils.m
//  XXToolKit
//
//  Created by Zhao yang on 12/11/13.
//  Copyright (c) 2013 xuxiao. All rights reserved.
//

#import "XXStringUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation XXStringUtils

+ (NSString *)noNilStringWithString:(NSString *)str {
    if(str == nil) return @"";
    return str;
}

+ (BOOL)isEmpty:(NSString *)str {
    if(str == nil || [@"" isEqualToString:str]) return YES;
    return NO;
}

+ (BOOL)isBlank:(NSString *)str {
    if([XXStringUtils isEmpty:str]) return YES;
    if([@"" isEqualToString:
        [str stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
            return YES;
        }
    return NO;
}

+ (NSString *)trim:(NSString *)str {
    if(str != nil) {
        return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return nil;
}

+ (NSString *)emptyString {
    return @"";
}

+ (NSString *)stringEncodeWithBase64:(NSString *)str {
    NSData *theData = [str dataUsingEncoding: NSASCIIStringEncoding];
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+ (NSString *)md5HexDigest:(NSString *)str {
    if(str == nil) return nil;
    const char *original_str = str.UTF8String;
    unsigned char result[16];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [[hash lowercaseString] substringWithRange:NSMakeRange(8, 16)];
}

+ (BOOL)string:(NSString *)s1 isEqualString:(NSString *)s2 {
    if(s1 != nil && s2 != nil) {
        return [s1 isEqualToString:s2];
    } else if(s1 == nil && s2 == nil) {
        return YES;
    } else {
        return NO;
    }
}

@end
