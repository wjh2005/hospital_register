//
//  XXEventFilterChain.m
//  XXToolKit
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 xuxiao. All rights reserved.
//

#import "XXEventFilterChain.h"

@implementation XXEventFilterChain {
    NSMutableArray *filters;
}

- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    filters = [NSMutableArray array];
}

- (XXEventFilterChain *)orFilter:(XXEventFilter *)filter {
    [filters addObject:filter];
    return self;
}

- (void)removeAllFilters {
    [filters removeAllObjects];
}

- (NSInteger)count {
    return filters.count;
}

- (BOOL)apply:(XXEvent *)event {
    if(filters.count == 0) return NO;
    for(int i=0; i<filters.count; i++) {
        XXEventFilter *filter = [filters objectAtIndex:i];
        if([filter apply:event]) {
            return YES;
        }
    }
    return NO;
}

@end
