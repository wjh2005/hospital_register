//
//  XXEventFilterChain.h
//  XXToolKit
//
//  Created by Zhao yang on 12/12/13.
//  Copyright (c) 2013 xuxiao. All rights reserved.
//

#import "XXEventFilter.h"

@interface XXEventFilterChain : XXEventFilter

@property (assign, nonatomic, readonly) NSInteger count;

- (XXEventFilterChain *)orFilter:(XXEventFilter *)filter;
- (void)removeAllFilters;

@end
