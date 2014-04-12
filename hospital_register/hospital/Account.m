//
//  Account.m
//  hospital
//
//  Created by Zhao yang on 3/21/14.
//
//

#import <Reddydog/XXStringUtils.h>
#import "Account.h"

@implementation Account

@synthesize name = _name_;
@synthesize birth;
@synthesize gender;
@synthesize bodyHeight;
@synthesize bodyWeight;
@synthesize address;
@synthesize mobile;
@synthesize clinicCard = _clinicCard_;

+ (instancetype)myAccount {
    static Account *account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [[[self class] alloc] init];
    });
    return account;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        // this only used for demo
        [self generateMockData];
    }
    return self;
}

- (NSString *)name {
    if(_name_ == nil) {
        _name_ = [XXStringUtils emptyString];
    }
    return _name_;
}

- (ClinicCard *)clinicCard {
    if(_clinicCard_ == nil) {
        _clinicCard_ = [[ClinicCard alloc] init];
    }
    return _clinicCard_;
}

/*
 * Mock data used for Demo app
 */
- (void)generateMockData {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.name = @"王文涛";
    self.gender = GenderFemale;
    self.bodyHeight = 175.f;
    self.bodyWeight = 60.f;
    self.birth = [dateFormatter dateFromString:@"1987-12-09"];
    self.address = @"岳麓区文轩路299号";
    self.mobile = @"18688881234";
    self.clinicCard.cardNumber = @"6228 7447 209";
}

@end
