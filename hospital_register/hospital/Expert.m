//
// Created by Zhao yang on 3/17/14.
//

#import "Expert.h"

@implementation Expert {

}

@synthesize department;
@synthesize name;
@synthesize imageUrl;
@synthesize registerNumbersRemain;

@synthesize expertIdleDates = _expertIdleDates_;
@synthesize expertIdleTimes = _expertIdleTimes_;

@synthesize post;
@synthesize introduce;
@synthesize shortIntroduce;
@synthesize registerPrice;

- (BOOL)isIdleForExpertIdleDate:(ExpertIdleDate)expertIdleDate {
    if(expertIdleDate == ExpertIdleDateNone) return NO;
    return (self.expertIdleDates & expertIdleDate)  == expertIdleDate;
}

- (BOOL)isIdleForExpertIdleDate:(ExpertIdleDate)expertIdleDate expertIdleTime:(ExpertIdleTime)expertIdleTime {
    if(self.expertIdleTimes == nil) return NO;
    if(![self isIdleForExpertIdleDate:expertIdleDate]) return NO;

    NSNumber *idleDateNumberKey = [self findNumberKeyForExpertIdleDate:expertIdleDate];

    if(idleDateNumberKey == nil) return NO;

    NSNumber *idleTime = [self.expertIdleTimes objectForKey:idleDateNumberKey];
    return (idleTime.integerValue & expertIdleTime) == expertIdleTime;
}

- (void)addExpertIdleDate:(ExpertIdleDate)expertIdleDate expertIdleTime:(ExpertIdleTime)expertIdleTime {

    // find the idleDate exists in dictionary ?
    if(self.expertIdleTimes == nil) {
        self.expertIdleTimes = [NSMutableDictionary dictionary];
    }

    NSNumber *idleDateNumberKey = [self findNumberKeyForExpertIdleDate:expertIdleDate];

    // if idleDate doesn't exists, create new
    if(idleDateNumberKey == nil) {
        idleDateNumberKey = [NSNumber numberWithInteger:expertIdleDate];
    }

    // set idleTime for idleDate
    [self.expertIdleTimes setObject:[NSNumber numberWithInteger:expertIdleTime] forKey:idleDateNumberKey];

    // add idle date
    self.expertIdleDates |= expertIdleDate;
}

- (ExpertIdleTime)expertIdleTimeFor:(ExpertIdleDate)expertIdleDate {
    NSNumber *key = [self findNumberKeyForExpertIdleDate:expertIdleDate];
    if(key == nil) return ExpertIdleTimeNone;
    NSNumber *idleTimesNumber = [self.expertIdleTimes objectForKey:key];
    return idleTimesNumber.integerValue;
}

- (NSInteger)idleDaysInWeek {
    NSInteger idleDays = 0;
    for(int i=0; i<7; i++) {
        BOOL isIdle = [self isIdleForExpertIdleDate:(1 << i)];
        if(isIdle) idleDays++;
    }
    return idleDays;
}

#pragma mark -
#pragma mark Internal

- (NSNumber *)findNumberKeyForExpertIdleDate:(ExpertIdleDate)expertIdleDate {
    if(self.expertIdleTimes == nil) return nil;
    NSArray *allKeys = self.expertIdleTimes.allKeys;
    if(allKeys == nil) return nil;
    for(NSNumber *key in allKeys) {
        if(key.integerValue == expertIdleDate) {
            return key;
        }
    }
    return nil;
}

@end