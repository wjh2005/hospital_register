//
//  XXEventSubscriptionDispatcher.m
//  XXToolKit
//
//  Created by Zhao yang on 12/11/13.
//  Copyright (c) 2013 xuxiao. All rights reserved.
//

#import "XXEventSubscriptionPublisher.h"
#import "XXStringUtils.h"

@implementation XXEventSubscriptionPublisher {
    NSMutableArray *subscriptions;
}

- (id)init {
    self = [super init];
    if(self) {
        subscriptions = [NSMutableArray array];
    }
    return self;
}

+ (XXEventSubscriptionPublisher *)defaultPublisher {
    static XXEventSubscriptionPublisher *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[XXEventSubscriptionPublisher alloc] init];
    });
    return manager;
}

#pragma mark -
#pragma mark Publish event

- (void)publishWithEvent:(XXEvent *)event {
    NSArray *allSubscriptions = nil;
    @synchronized(self) {
        allSubscriptions = [NSArray arrayWithArray:subscriptions];
    }
    for(int i=0; i<allSubscriptions.count; i++) {
        XXEventSubscription *subscription = [allSubscriptions objectAtIndex:i];
        [subscription notifyWithEvent:event];
    }
}

- (void)publishWithEvent:(XXEvent *)event exceptSubscriber:(id<XXEventSubscriber>)subscriber {
    if(subscriber == nil) {
        [self publishWithEvent:event];
        return;
    }
    [self publishWithEvent:event exceptSubscriberId:[subscriber xxEventSubscriberIdentifier]];
}

- (void)publishWithEvent:(XXEvent *)event exceptSubscriberId:(NSString *)subscriberId {
    if([XXStringUtils isBlank:subscriberId]) {
        [self publishWithEvent:event];
        return;
    }
    [self publishWithEvent:event exceptSubscriberIdsArray:[NSArray arrayWithObjects:subscriberId, nil]];
}

- (void)publishWithEvent:(XXEvent *)event exceptSubscribersArray:(NSArray *)subscribers {
    NSMutableArray *subscriberIds = [NSMutableArray array];
    if(subscribers != nil) {
        for(int i=0; i<subscribers.count; i++) {
            id<XXEventSubscriber> sb = [subscribers objectAtIndex:i];
            [subscriberIds addObject:[sb xxEventSubscriberIdentifier]];
        }
    }
    [self publishWithEvent:event exceptSubscriberIdsArray:subscriberIds];
}

- (void)publishWithEvent:(XXEvent *)event exceptSubscriberIdsArray:(NSArray *)subscriberIds {
    if(subscriberIds == nil || subscriberIds.count == 0) {
        [self publishWithEvent:event];
        return;
    }
    NSArray *allSubscriptions = nil;
    @synchronized(self) {
        allSubscriptions = [NSArray arrayWithArray:subscriptions];
    }
    for(int i=0; i<allSubscriptions.count; i++) {
        XXEventSubscription *subscription = [allSubscriptions objectAtIndex:i];
        if(subscription.subscriber == nil) continue;
        if(![self subscriberIdsArray:subscriberIds isContainsSubscriber:subscription.subscriber]) {
            [subscription notifyWithEvent:event];
        }
    }
}

- (BOOL)subscriberIdsArray:(NSArray *)subscriberIds isContainsSubscriber:(id<XXEventSubscriber>)subscriber {
    for(int i=0; i<subscriberIds.count; i++) {
        NSString *sid = [subscriberIds objectAtIndex:i];
        if([[subscriber xxEventSubscriberIdentifier] isEqualToString:sid]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark Subscribe && unSubscribe subscriptions

- (void)subscribeFor:(XXEventSubscription *)subscription {
    if(subscription == nil) return;
    @synchronized(self) {
        [subscriptions addObject:subscription];
    }
#ifdef DEBUG
    NSLog(@"[EVENT PUBLISHER] Subscribe Event For [%@].", subscription.subscriber == nil ? @"" : [subscription.subscriber xxEventSubscriberIdentifier]);
#endif
}

- (void)unsubscribeAllSubscriptions {
    @synchronized(self) {
        [subscriptions removeAllObjects];
    }
#ifdef DEBUG
    NSLog(@"[EVENT PUBLISHER] Unsubscribe All Subscriptions.");
#endif
}

- (void)unSubscribeForSubscription:(XXEventSubscription *)subscription {
    if(subscription == nil) return;
    @synchronized(self) {
        [subscriptions removeObject:subscription];
    }
#ifdef DEBUG
    NSLog(@"[EVENT PUBLISHER] Unsubscribe Event For [%@].", subscription.subscriber == nil ? @"" : [subscription.subscriber xxEventSubscriberIdentifier]);
#endif
}

- (void)unSubscribeForSubscriber:(id<XXEventSubscriber>)subscriber {
    if(subscriber != nil) {
        [self unSubscribeForSubscriberId:[subscriber xxEventSubscriberIdentifier]];
    }
}

- (void)unSubscribeAllSubscriptionsExceptSubscriberId:(NSString *)subscriberId {
    @synchronized(self) {
        if([XXStringUtils isBlank:subscriberId]) {
            [subscriptions removeAllObjects];
#ifdef DEBUG
            NSLog(@"[EVENT PUBLISHER] Unsubscribe All Subscriptions.");
#endif
            return;
        }
        XXEventSubscription *found = nil;
        for(int i=0; i<subscriptions.count; i++) {
            XXEventSubscription *subscription = [subscriptions objectAtIndex:i];
            if(subscription.subscriber != nil) {
                if([subscriberId isEqualToString:[subscription.subscriber xxEventSubscriberIdentifier]]) {
                    found = subscription;
                    break;
                }
            }
        }
        [subscriptions removeAllObjects];
        if(found != nil) {
            [subscriptions addObject:found];
#ifdef DEBUG
            NSLog(@"[EVENT PUBLISHER] Unsubscribe All Subscriptions, Except [%@].", [found.subscriber xxEventSubscriberIdentifier]);
#endif
        } else {
#ifdef DEBUG
            NSLog(@"[EVENT PUBLISHER] Unsubscribe All Subscriptions.");
#endif
        }
    }
}

- (void)unSubscribeForSubscriberId:(NSString *)subscriberId {
    if([XXStringUtils isEmpty:subscriberId]) return;
    @synchronized(self) {
        NSMutableArray *removedList = [NSMutableArray array];
        for(int i=0; i<subscriptions.count; i++) {
            XXEventSubscription *subscription = [subscriptions objectAtIndex:i];
            if(subscription.subscriber != nil && [subscriberId isEqualToString:[subscription.subscriber xxEventSubscriberIdentifier]]) {
                [removedList addObject:subscription];
            }
        }
        
        for(int i=0; i<removedList.count; i++) {
            XXEventSubscription *subscription = [removedList objectAtIndex:i];
            [subscriptions removeObject:subscription];
#ifdef DEBUG
            NSLog(@"[EVENT PUBLISHER] Unsubscribe Event For [%@].", subscription.subscriber == nil ? @"" : [subscription.subscriber xxEventSubscriberIdentifier]);
#endif
        }
    }
}

@end
