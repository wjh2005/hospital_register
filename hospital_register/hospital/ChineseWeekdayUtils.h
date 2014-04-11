//
// Created by Zhao yang on 3/19/14.
//

#import <Foundation/Foundation.h>


@interface ChineseWeekdayUtils : NSObject

+ (NSInteger)chineseWeekDayToday;
+ (NSInteger)chineseWeekDayForDate:(NSDate *)date;
+ (NSString *)chineseWeekDayWithWeekdayNumber:(NSInteger)weekdayNumber;

@end