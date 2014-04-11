//
// Created by Zhao yang on 3/22/14.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "Expert.h"

typedef NS_ENUM(NSInteger , RegisterType) {
    RegisterTypeOutpatient = 1,
    RegisterTypeExpert     = 2
};

@interface RegisterOrder : Entity

@property (nonatomic) RegisterType registerType;
@property (nonatomic, strong) NSDate *registerDate;
@property (nonatomic) ExpertIdleTime expertIdleTime;
@property (nonatomic, strong) Expert *expert;
@property (nonatomic, strong) Department *department;

- (NSString *)formattedRegisterDateStringWithWeekDay;
- (NSString *)formattedRegisterDateString;

@end