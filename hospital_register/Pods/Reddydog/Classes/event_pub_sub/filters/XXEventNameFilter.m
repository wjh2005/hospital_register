//
//  XXEventNameFilter.m
//  SmartHome
//
//  Created by Zhao yang on 12/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXEventNameFilter.h"

@implementation XXEventNameFilter {
    NSMutableArray *_supportedEventNames_;
}

- (id)init {
    self = [super init];
    if(self) {
        _supportedEventNames_ = [NSMutableArray array];
    }
    return self;
}

- (id)initWithSupportedEventName:(NSString *)supportedEventName {
    self = [super init];
    if(self) {
        _supportedEventNames_ = [NSMutableArray array];
        if(supportedEventName != nil) {
            [_supportedEventNames_ addObject:supportedEventName];
        }
    }
    return self;
}

- (id)initWithSupportedEventNames:(NSArray *)supportedEventNames {
    self = [super init];
    if(self) {
        if(supportedEventNames != nil) {
            _supportedEventNames_ = [NSMutableArray arrayWithArray:supportedEventNames];
        } else {
            _supportedEventNames_ = [NSMutableArray array];
        }
    }
    return self;
}

- (BOOL)apply:(XXEvent *)event {
    if(event != nil && _supportedEventNames_ != nil) {
        for(int i=0; i<_supportedEventNames_.count; i++) {
            NSString *eventName = [_supportedEventNames_ objectAtIndex:i];
            if([eventName isEqualToString:event.name]) {
                return YES;
            }
        }
    }
    return NO;
}

- (XXEventNameFilter *)addSupportedEventName:(NSString *)eventName {
    if(_supportedEventNames_ == nil) {
        _supportedEventNames_ = [NSMutableArray array];
    }
    if(eventName != nil) {
        [_supportedEventNames_ addObject:eventName];
    }
    return self;
}

- (void)removeAllSupportedEventNames {
    if(_supportedEventNames_ != nil) {
        [_supportedEventNames_ removeAllObjects];
    }
}

@end
