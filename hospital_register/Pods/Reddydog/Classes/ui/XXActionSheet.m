//
//  XXActionSheet.m
//  SmartHome
//
//  Created by Zhao yang on 12/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXActionSheet.h"

@implementation XXActionSheet

@synthesize parameters = _parameters_;
@synthesize identifier;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setParameter:(id)parameter forKey:(NSString *)key {
    [self.parameters setObject:parameter forKey:key];
}

- (id)parameterForKey:(NSString *)key {
    return [self.parameters objectForKey:key];
}

- (NSMutableDictionary *)parameters {
    if(_parameters_ == nil) {
        _parameters_ = [NSMutableDictionary dictionary];
    }
    return _parameters_;
}

@end
