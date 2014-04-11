//
//  XXAlertView.m
//  SmartHome
//
//  Created by Zhao yang on 8/16/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXAlertView.h"
#import "XXStringUtils.h"
#import <QuartzCore/QuartzCore.h>

#define DELAY_DURATION          1.0f
#define ANIMATION_DURATION      0.4f
#define BACKGROUND_VIEW_ALPHA   0.8f

@implementation XXAlertView {
    NSTimer *timer;
    NSTimer *timeoutTimer;
    UILabel *lblMessage;
    UIImageView *imgTips;
    UIActivityIndicatorView *indicatorView;
    UIView *lockedView;
}

@synthesize alertViewType;
@synthesize alertViewState;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
        [self initUI];
    }
    return self;
}

- (void)initDefaults {
    self.alertViewState = AlertViewStateReady;
}

- (void)initUI {
    self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = 10;
    self.alpha = 0;
    
    if(imgTips == nil) {
        imgTips = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        imgTips.center = CGPointMake(self.center.x, 30);
        [self addSubview:imgTips];
    }
    
    if(indicatorView == nil) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicatorView.center = CGPointMake(self.center.x, 30);
        [self addSubview:indicatorView];
    }
    
    if(lblMessage == nil) {
        lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, 130, 21)];
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.textAlignment = NSTextAlignmentCenter;
        lblMessage.font = [UIFont systemFontOfSize:15.f];
        lblMessage.textColor = [UIColor whiteColor];
        [self addSubview:lblMessage];
    }
}

+ (instancetype)currentAlertView {
    static XXAlertView *currentAlertView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        currentAlertView = [[[self class] alloc] initWithFrame:CGRectMake(0, 0, 140, 88)];
        currentAlertView.center = CGPointMake(keyWindow.center.x, keyWindow.center.y);
    });
    return currentAlertView;
}

- (void)alertForLock:(BOOL)isLock autoDismiss:(BOOL)autoDismiss {
    if(self.alertViewState != AlertViewStateReady) return;
    self.alertViewState = AlertViewStateWillAppear;
    UIWindow *lastWindow = [self lastWindow];
    if(isLock) {
        lockedView = [[UIView alloc] initWithFrame:lastWindow.bounds];
        lockedView.backgroundColor = [UIColor blackColor];
        lockedView.alpha = 0.2f;
        [lastWindow addSubview:lockedView];
    }
    [lastWindow addSubview:self];
    if(self.alertViewType == AlertViewTypeWaitting) {
        if(!indicatorView.isAnimating) {
            [indicatorView startAnimating];
        }
    }
    [UIView animateWithDuration:ANIMATION_DURATION
            animations:^{
                self.alpha = BACKGROUND_VIEW_ALPHA;
            }
            completion:^(BOOL finished) {
                self.alertViewState = AlertViewStateDidAppear;
                if(autoDismiss) {
                    [self delayDismissAlertView];
                }
            }];
}

- (void)alertForLock:(BOOL)isLock timeout:(NSTimeInterval)timeout timeoutMessage:(NSString *)message {
    [self alertForLock:isLock autoDismiss:NO];
    if(message == nil) {
        message = [XXStringUtils emptyString];
    }
    timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(alertTimeout:) userInfo:[NSDictionary dictionaryWithObject:message forKey:@"timeoutMsgKey"] repeats:NO];
}

- (void)alertTimeout:(NSTimer *)tTimer {
    if(self.alertViewState == AlertViewStateWillAppear || self.alertViewState == AlertViewStateDidAppear) {
        if(tTimer.userInfo != nil) {
            [self setMessage:[tTimer.userInfo objectForKey:@"timeoutMsgKey"] forType:AlertViewTypeFailed];
        }
        [self delayDismissAlertView];
    }
    timeoutTimer = nil;
}

- (void)delayDismissAlertView {
    if(timeoutTimer != nil && timeoutTimer.isValid) {
        [timeoutTimer invalidate];
    }
    timeoutTimer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:DELAY_DURATION target:self selector:@selector(dismissAlertView) userInfo:nil repeats:NO];
}

- (void)dismissAlertView {
    if(timer != nil && timer.isValid) {
        [timer invalidate];
    }
    timer = nil;
    if(timeoutTimer != nil && timeoutTimer.isValid) {
        [timeoutTimer invalidate];
    }
    timeoutTimer = nil;
    if(self.alertViewState == AlertViewStateWillAppear || self.alertViewState == AlertViewStateDidAppear) {
        self.alertViewState = AlertViewStateWillDisappear;
        [UIView animateWithDuration:ANIMATION_DURATION
                animations:^{
                    self.alpha = 0;
                }
                completion:^(BOOL finished) {
                    if(indicatorView.isAnimating) {
                        [indicatorView stopAnimating];
                    }
                    [self removeFromSuperview];
                    if(lockedView != nil) {
                        [lockedView removeFromSuperview];
                        lockedView = nil;
                    }
                    self.alertViewState = AlertViewStateReady;
                }];
    }
}

- (void)setMessage:(NSString *)message forType:(AlertViewType)type {
    if(message == nil) message = [XXStringUtils emptyString];
    lblMessage.text = [XXStringUtils trim:message];
    alertViewType = type;
    switch (type) {
        case AlertViewTypeNone:
            indicatorView.hidden = YES;
            imgTips.hidden = YES;
            lblMessage.text = [XXStringUtils emptyString];
            break;
        case AlertViewTypeWaitting:
            indicatorView.hidden = NO;
            imgTips.hidden = YES;
            break;
        case AlertViewTypeSuccess:
            indicatorView.hidden = YES;
            imgTips.hidden = NO;
            imgTips.image = [UIImage imageNamed:@"alert_success"];
            break;
        case AlertViewTypeFailed:
            indicatorView.hidden = YES;
            imgTips.hidden = NO;
            imgTips.image = [UIImage imageNamed:@"alert_failed"];
            break;
        default:
            break;
    }
}

- (UIWindow *)lastWindow {
    NSArray *windows = [UIApplication sharedApplication].windows;
    return [windows objectAtIndex:windows.count - 1];
}

@end
