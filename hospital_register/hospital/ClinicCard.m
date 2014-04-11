//
//  ClinicCard.m
//  hospital
//
//  Created by Zhao yang on 3/21/14.
//
//

#import <Reddydog/XXStringUtils.h>
#import "ClinicCard.h"

@implementation ClinicCard

@synthesize cardNumber = _cardNumber_;

- (NSString *)cardNumber {
    if(_cardNumber_ == nil) {
        _cardNumber_ = [XXStringUtils emptyString];
    }
    return _cardNumber_;
}

@end
