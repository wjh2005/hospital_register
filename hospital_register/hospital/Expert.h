//
// Created by Zhao yang on 3/17/14.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "SearchableString.h"

typedef NS_ENUM(NSInteger, ExpertIdleDate) {
    ExpertIdleDateNone        =    0,
    ExpertIdleDateMonday      =    1 << 0,
    ExpertIdleDateTuesday     =    1 << 1,
    ExpertIdleDateWednesday   =    1 << 2,
    ExpertIdleDateThursday    =    1 << 3,
    ExpertIdleDateFriday      =    1 << 4,
    ExpertIdleDateSaturday    =    1 << 5,
    ExpertIdleDateSunday      =    1 << 6,
};

typedef NS_ENUM(NSInteger, ExpertIdleTime) {
    ExpertIdleTimeNone                     =    0,
    ExpertIdleTimeMorning                  =    1 << 0,
    ExpertIdleTimeAfternoon                =    1 << 1,
    ExpertIdleTimeMorningAndAfternoon      =    ExpertIdleTimeMorning | ExpertIdleTimeAfternoon,
    ExpertIdleTimeEvening                  =    1 << 2,
};

@class SearchableString;
@class Department;

@interface Expert : Entity

/* Weak reference for class 'Department'
 * to avoid retain cycle
 */
@property (nonatomic, weak) Department *department;

@property (nonatomic, strong) SearchableString *name;

@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) NSString *post;

@property (nonatomic, strong) NSString *introduce;

@property (nonatomic, strong) NSString *shortIntroduce;

@property (nonatomic) float registerPrice;

@property (nonatomic) NSInteger registerNumbersRemain;

/*
 * Integer for idle dates
 *
 * i.e
 * Monday               0x 0000 0001
 * Tuesday              0x 0000 0010
 * Monday and Tuesday   0x 0000 0011
 * ... ...
 *
 */
@property (nonatomic) NSInteger expertIdleDates;

/*
 * i.e
 *
 * @ {
 *       ExpertIdleDateMonday      :    ExpertIdleTimeMorning,
 *       ExpertIdleDateSaturday    :    ExpertIdleTimeAfternoon,
 *       ExpertIdleDateSunday      :    ExpertIdleTimeEvening
 * }
 */
@property (nonatomic, strong) NSMutableDictionary *expertIdleTimes;

- (BOOL)isIdleForExpertIdleDate:(ExpertIdleDate)expertIdleDate;
- (BOOL)isIdleForExpertIdleDate:(ExpertIdleDate)expertIdleDate expertIdleTime:(ExpertIdleTime)expertIdleTime;
- (void)addExpertIdleDate:(ExpertIdleDate)expertIdleDate expertIdleTime:(ExpertIdleTime)expertIdleTime;
- (ExpertIdleTime)expertIdleTimeFor:(ExpertIdleDate)expertIdleDate;

- (NSInteger)idleDaysInWeek;

@end
