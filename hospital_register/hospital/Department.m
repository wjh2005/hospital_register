//
// Created by Zhao yang on 3/15/14.
//

#import "Department.h"

@implementation Department {

}

@synthesize identifier = _identifier_;
@synthesize name = _name_;
@synthesize experts = _experts_;
@synthesize departmentType = _departmentType_;
@synthesize introduce;
@synthesize registerPrice;

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name departmentType:(DepartmentType)departmentType {
    self = [super init];
    if(self) {
        self.identifier = identifier;
        self.name = [[SearchableString alloc] initWithString:name];
        self.departmentType = departmentType;
    }
    return self;
}

- (NSArray *)idleExpertsForExpertIdleDate:(ExpertIdleDate)expertIdleDate {
    NSMutableArray *experts = [NSMutableArray array];
    for(int i=0; i<self.experts.count; i++) {
        Expert *expert = [self.experts objectAtIndex:i];
        if([expert isIdleForExpertIdleDate:expertIdleDate]) {
            [experts addObject:expert];
        }
    }

    return experts;
}

- (NSMutableArray *)experts {
    if(_experts_ == nil) {
        _experts_ = [NSMutableArray array];
    }
    return _experts_;
}

- (BOOL)isNormalOutpatient {
    return DepartmentTypeNormalOutpatient == (self.departmentType & DepartmentTypeNormalOutpatient);
}

- (BOOL)isExpertOutpatient {
    return DepartmentTypeExpertOutpatient == (self.departmentType & DepartmentTypeExpertOutpatient);
}

@end