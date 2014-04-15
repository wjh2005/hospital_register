//
//  NSMutableDictionary+Extension.h
//  SmartHome
//
//  Created by Zhao yang on 9/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXStringUtils.h"

@interface NSMutableDictionary (Extension)

- (void)setInteger:(NSInteger)integer forKey:(id<NSCopying>)key;
- (void)setDouble:(double)db forKey:(id<NSCopying>)key;
- (void)setDateUsingTimeIntervalSince1970:(NSDate *)date forKey:(id<NSCopying>)key;
- (void)setLongLong:(long long)ll forKey:(id<NSCopying>)key;
// 用毫秒保存Date
- (void)setDateWithMilliseconds:(NSDate *)date forKey:(id<NSCopying>)key;
- (void)setNoNilObject:(id)object forKey:(id<NSCopying>)key;
- (void)setNoBlankString:(NSString *)string forKey:(id<NSCopying>)key;

// Deprecated , use setBoolean to instead it
- (void)setBool:(BOOL)b forKey:(id<NSCopying>)key __attribute__((deprecated));
- (void)setBoolean:(BOOL)b forKey:(id<NSCopying>)key;

- (void)setMayBlankString:(NSString *)string forKey:(id<NSCopying>)key;

@end
