//
//  XXEventSubscription.m
//  XXToolKit
//
//  Created by Zhao yang on 12/11/13.
//  Copyright (c) 2013 xuxiao. All rights reserved.
//

#import "XXEventSubscription.h"

@implementation XXEventSubscription

@synthesize subscriber = _subscriber_;
@synthesize filter = _filter_;
@synthesize notifyMustInMainThread;

- (id)initWithSubscriber:(id<XXEventSubscriber>)subscriber {
    self = [super init];
    if(self) {
        _subscriber_ = subscriber;
    }
    return self;
}

- (id)initWithSubscriber:(id<XXEventSubscriber>)subscriber eventFilter:(XXEventFilter *)filter {
    self = [super init];
    if(self) {
        _subscriber_ = subscriber;
        _filter_ = filter;
    }
    return self;
}

- (void)notifyWithEvent:(XXEvent *)event {
    if(_filter_ != nil && [_filter_ apply:event]) {
        if(self.subscriber != nil) {
            if(self.notifyMustInMainThread) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.subscriber xxEventPublisherNotifyWithEvent:event];
                });
            } else {
                [self.subscriber xxEventPublisherNotifyWithEvent:event];
            }
        }
    }
}

@end
