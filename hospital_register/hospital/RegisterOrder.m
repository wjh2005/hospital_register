//
// Created by Zhao yang on 3/22/14.
//

#import "RegisterOrder.h"
#import "Expert.h"
#import "Department.h"
#import "ChineseWeekdayUtils.h"
#import "Configs.h"

@implementation RegisterOrder {

}

@synthesize registerType;
@synthesize expertIdleTime;
@synthesize expert = _expert_;
@synthesize department = _department_;

- (instancetype)init {
    self = [super init];
    if(self) {
        self.expertIdleTime = ExpertIdleTimeNone;
    }
    return self;
}

- (Department *)department {
    if(self.registerType == RegisterTypeOutpatient) {
        return _department_;
    } else {
        if(_department_ != nil) return _department_;

        if(_expert_ != nil) {
            return _expert_.department;
        }
        return nil;
    }
}

- (NSString *)formattedRegisterDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [Configs defaultConfigs].defaultTimeZone;
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    if(RegisterTypeExpert == self.registerType) {
        NSString *timeString =
                self.expertIdleTime == ExpertIdleTimeAfternoon ? NSLocalizedString(@"afternoon", @"") : NSLocalizedString(@"morning", @"");
        return [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:self.registerDate], timeString];
    } else {
        NSString *timeString;
        if(ExpertIdleTimeMorning == self.expertIdleTime) {
            timeString = NSLocalizedString(@"morning", @"");
        } else if(ExpertIdleTimeAfternoon == self.expertIdleTime) {
            timeString = NSLocalizedString(@"afternoon", @"");
        } else if(ExpertIdleTimeEvening == self.expertIdleTime) {
            timeString = NSLocalizedString(@"evening", @"");

        }
        return [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:self.registerDate], timeString];
    }
}
- (NSString *)formattedRegisterDateStringWithWeekDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [Configs defaultConfigs].defaultTimeZone;
    dateFormatter.dateFormat = @"yyyy-MM-dd";

    NSInteger weekDay = [ChineseWeekdayUtils chineseWeekDayForDate:self.registerDate];
    NSString *weekDayString = [ChineseWeekdayUtils chineseWeekDayWithWeekdayNumber:weekDay];

    if(RegisterTypeExpert == self.registerType) {
        NSString *timeString =
                self.expertIdleTime == ExpertIdleTimeAfternoon ? NSLocalizedString(@"afternoon", @"") : NSLocalizedString(@"morning", @"");
        return [NSString stringWithFormat:@"%@ %@ %@", [dateFormatter stringFromDate:self.registerDate], weekDayString, timeString];
    } else {
        NSString *timeString;
        if(ExpertIdleTimeMorning == self.expertIdleTime) {
            timeString = NSLocalizedString(@"morning", @"");
        } else if(ExpertIdleTimeAfternoon == self.expertIdleTime) {
            timeString = NSLocalizedString(@"afternoon", @"");
        } else if(ExpertIdleTimeEvening == self.expertIdleTime) {
            timeString = NSLocalizedString(@"evening", @"");
        }
        return [NSString stringWithFormat:@"%@ %@ %@", [dateFormatter stringFromDate:self.registerDate], weekDayString, timeString];
    }
}

@end