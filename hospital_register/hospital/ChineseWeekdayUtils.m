//
// Created by Zhao yang on 3/19/14.
//

#import "ChineseWeekdayUtils.h"
#import "XXStringUtils.h"


@implementation ChineseWeekdayUtils {

}

+ (NSInteger)chineseWeekDayForDate:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    return dateComponents.weekday == 1 ? 7 : (dateComponents.weekday - 1);
}

+ (NSInteger)chineseWeekDayToday {
    NSDate *now = [NSDate date];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:now];
    return dateComponents.weekday == 1 ? 7 : (dateComponents.weekday - 1);
}

+ (NSString *)chineseWeekDayWithWeekdayNumber:(NSInteger)weekdayNumber {
    NSString *chineseWeekDay = [XXStringUtils emptyString];
    switch (weekdayNumber) {
        case 1:
            chineseWeekDay = NSLocalizedString(@"monday", @"");
            break;
        case 2:
            chineseWeekDay = NSLocalizedString(@"tuesday", @"");
            break;
        case 3:
            chineseWeekDay = NSLocalizedString(@"wednesday", @"");
            break;
        case 4:
            chineseWeekDay = NSLocalizedString(@"thursday", @"");
            break;
        case 5:
            chineseWeekDay = NSLocalizedString(@"friday", @"");
            break;
        case 6:
            chineseWeekDay = NSLocalizedString(@"saturday", @"");
            break;
        case 7:
            chineseWeekDay = NSLocalizedString(@"sunday", @"");
            break;
    }
    return chineseWeekDay;
}
@end