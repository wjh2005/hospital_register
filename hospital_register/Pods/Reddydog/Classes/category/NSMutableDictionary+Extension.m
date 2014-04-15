//
//  NSMutableDictionary+Extension.m
//  SmartHome
//
//  Created by Zhao yang on 9/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NSMutableDictionary+Extension.h"

@implementation NSMutableDictionary (Extension)

- (void)setInteger:(NSInteger)integer forKey:(id<NSCopying>)key {
    [self setObject:[NSNumber numberWithInteger:integer] forKey:key];
}

- (void)setDouble:(double)db forKey:(id<NSCopying>)key {
    [self setObject:[NSNumber numberWithDouble:db] forKey:key];
}

- (void)setLongLong:(long long)ll forKey:(id<NSCopying>)key {
    [self setObject:[NSNumber numberWithDouble:ll] forKey:key];
}

/* if object is blank , return */
- (void)setNoNilObject:(id)object forKey:(id<NSCopying>)key {
    if(object == nil || object == [NSNull null]) return;
    [self setObject:object forKey:key];
}

/* if string is blank , return */
- (void)setNoBlankString:(NSString *)string forKey:(id<NSCopying>)key {
    if([XXStringUtils isBlank:string]) return;
    [self setObject:string forKey:key];
}

/* if string is blank , set an empty string for value */
- (void)setMayBlankString:(NSString *)string forKey:(id<NSCopying>)key {
    if([XXStringUtils isBlank:string]) {
        [self setObject:[XXStringUtils emptyString] forKey:key];
        return;
    }
    [self setObject:string forKey:key];
}

- (void)setDateUsingTimeIntervalSince1970:(NSDate *)date forKey:(id<NSCopying>)key {
    if(date == nil) return;
    [self setObject:[NSNumber numberWithDouble:date.timeIntervalSince1970] forKey:key];
}

/* if date is nil , return */
- (void)setDateWithMilliseconds:(NSDate *)date forKey:(id<NSCopying>)key {
    if(date == nil) return;
    [self setObject:[NSNumber numberWithLongLong:date.timeIntervalSince1970 * 1000] forKey:key];
}

- (void)setBool:(BOOL)b forKey:(id<NSCopying>)key {
    NSString *boolStr = b ? @"yes" : @"no";
    [self setObject:boolStr forKey:key];
}

- (void)setBoolean:(BOOL)b forKey:(id<NSCopying>)key {
    [self setObject:[NSNumber numberWithBool:b] forKey:key];
}

@end
