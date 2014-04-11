//
//  NSDictionary+Extension.m 
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

/****************************
 * can be nil
 ****************************/

- (id)notNSNullObjectForKey:(id)key {
    id obj = [self objectForKey:key];
    if(obj == [NSNull null]) return nil;
    return obj;
}

- (NSString *)stringForKey:(id)key {
    NSString *str = [self notNSNullObjectForKey:key];
    if(str != nil) {
        return str;
    }
    return nil;
}

- (NSNumber *)numberForKey:(id)key {
    return [self notNSNullObjectForKey:key];
}

- (NSDate *)dateWithTimeIntervalSince1970ForKey:(id)key {
    NSNumber *_date_ = [self notNSNullObjectForKey:key];
    if(_date_ == nil) return nil;
    return [NSDate dateWithTimeIntervalSince1970:_date_.doubleValue];
}

- (NSDate *)dateWithMillisecondsForKey:(id)key {
    NSNumber *_date_ = [self notNSNullObjectForKey:key];
    if(_date_ == nil) return nil;
    return [NSDate dateWithTimeIntervalSince1970:_date_.longLongValue / 1000];
}

- (NSArray *)arrayForKey:(id)key {
    return [self notNSNullObjectForKey:key];
}

- (NSDictionary *)dictionaryForKey:(id)key {
    return [self notNSNullObjectForKey:key];
}


/****************************
 * can not be nil
 ****************************/

- (int)intForKey:(id)key {
    NSNumber *number = [self notNSNullObjectForKey:key];
    if(number == nil) return 0;
    return number.intValue;
}

- (long)longForKey:(id)key {
    NSNumber *number = [self notNSNullObjectForKey:key];
    if(number == nil) return 0;
    return number.longValue;
}

- (long long)longlongForKey:(id)key {
    NSNumber *number = [self notNSNullObjectForKey:key];
    if(number == nil) return 0;
    return number.longLongValue;
}

- (double)doubleForKey:(id)key {
    NSNumber *number = [self notNSNullObjectForKey:key];
    if(number == nil) return 0;
    return number.doubleValue;
}

- (BOOL)boolForKey:(id)key {
    id _bool_ = [self notNSNullObjectForKey:key];
    if(_bool_ != nil) {
        if([_bool_ isKindOfClass:[NSNumber class]]) {
            NSNumber *num = (NSNumber *)_bool_;
            return num.integerValue == 1;
        } else if([_bool_ isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)_bool_;
            return [@"yes" isEqualToString:str] || [@"YES" isEqualToString:str];
        }
    }
    return NO;
}

- (BOOL)booleanForKey:(id)key {
    id _bool_ = [self notNSNullObjectForKey:key];
    if(_bool_ != nil) {
        if([_bool_ isKindOfClass:[NSNumber class]]) {
            NSNumber *num = (NSNumber *)_bool_;
            return num.boolValue;
        }
    }
    return NO;
}

- (NSString *)noNilStringForKey:(id)key {
    NSString *_str_ = [self notNSNullObjectForKey:key];
    if(_str_ == nil) {
        return [XXStringUtils emptyString];
    }
    return _str_;
}

@end
