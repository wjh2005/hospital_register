//
//  XXEventNameFilter.h
//  SmartHome
//
//  Created by Zhao yang on 12/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXEventFilter.h"

@interface XXEventNameFilter : XXEventFilter

- (id)initWithSupportedEventName:(NSString *)supportedEventName;
- (id)initWithSupportedEventNames:(NSArray *)supportedEventNames;

- (XXEventNameFilter *)addSupportedEventName:(NSString *)eventName;
- (void)removeAllSupportedEventNames;

@end
