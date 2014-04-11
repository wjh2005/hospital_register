//
// Created by Zhao yang on 3/25/14.
//

#import "RegisterNumber.h"

@implementation RegisterNumber {
}

@synthesize number = _number_;
@synthesize updateDate = _updateDate_;

- (instancetype)initWithNumber:(NSInteger)number updateDate:(NSDate *)updateDate {
    self = [super init];
    if(self) {
        self.number = number;
        self.updateDate = updateDate;
    }
    return self;
}

@end