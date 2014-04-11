//
//  XXEventSubscription.h
//  XXToolKit
//
//  Created by Zhao yang on 12/11/13.
//  Copyright (c) 2013 xuxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXEventSubscriber.h"
#import "XXEvent.h"
#import "XXEventFilter.h"

@interface XXEventSubscription : NSObject

@property (strong, nonatomic) id<XXEventSubscriber> subscriber;
@property (strong, nonatomic) XXEventFilter *filter;
@property (assign, nonatomic) BOOL notifyMustInMainThread;

- (id)initWithSubscriber:(id<XXEventSubscriber>)subscriber;
- (id)initWithSubscriber:(id<XXEventSubscriber>)subscriber eventFilter:(XXEventFilter *)filter;
- (void)notifyWithEvent:(XXEvent *)event;

@end
