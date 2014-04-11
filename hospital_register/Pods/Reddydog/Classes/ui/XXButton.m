//
//  XXButton.m
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXButton.h"

@implementation XXButton

@synthesize identifier;
@synthesize userObject;
@synthesize parameters = _parameters_;
@synthesize longPressDelegate = _longPressDelegate_;

#pragma mark -
#pragma mark Extension for parameters
    
- (void)setParameter:(id)object forKey:(NSString *)key {
    [self.parameters setObject:object forKey:key];
}
    
- (id)parameterForKey:(NSString *)key {
    return [self.parameters objectForKey:key];
}

#pragma mark -
#pragma mark Extension for long press

- (void)setLongPressDelegate:(id<LongPressDelegate>)longPressDelegate {
    for(UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if([gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gesture removeTarget:self action:@selector(longPressed:)];
        }
    }
    _longPressDelegate_ = longPressDelegate;
    if(_longPressDelegate_ != nil) {
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        [self addGestureRecognizer:longPressGesture];
    }
}

- (void)longPressed:(UILongPressGestureRecognizer *)gesture {
    if(self.longPressDelegate != nil && gesture.state == UIGestureRecognizerStateBegan) {
        [self.longPressDelegate xxButtonLongPressed:self];
    }
}

#pragma mark -
#pragma mark Properties

- (NSMutableDictionary *)parameters {
    if(_parameters_ == nil) {
        _parameters_ = [NSMutableDictionary dictionary];
    }
    return _parameters_;
}

@end
