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
    UIButton *btnCancel;
    
    XXAlertViewCancelledBlock _cancelled_block_;
}

@synthesize alertViewType;
@synthesize alertViewState;

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
    self.layer.shadowColor = [UIColor redColor].CGColor;
    self.layer.cornerRadius = 2;
    self.alpha = 0;
    
    imgTips = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    imgTips.center = CGPointMake(self.center.x, 30);
    [self addSubview:imgTips];

    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicatorView.center = CGPointMake(self.center.x, 30);
    [self addSubview:indicatorView];
    
    lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, 130, 21)];
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.font = [UIFont systemFontOfSize:14.f];
    lblMessage.textColor = [UIColor whiteColor];
    [self addSubview:lblMessage];
    
    btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 48 / 2, 0, 48 / 2, 45.f / 2)];
    btnCancel.layer.cornerRadius = 1;
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.hidden = YES;
    [self addSubview:btnCancel];
}

- (void)alertForLock:(BOOL)isLock autoDismiss:(BOOL)autoDismiss cancelledBlock:(XXAlertViewCancelledBlock)cancelledBlock {
    [self alertForLock:isLock autoDismiss:autoDismiss];
    _cancelled_block_ = cancelledBlock;
    btnCancel.hidden = _cancelled_block_ == NULL || _cancelled_block_ == nil;
}

- (void)alertForLock:(BOOL)isLock autoDismiss:(BOOL)autoDismiss {
    if(self.alertViewState != AlertViewStateReady) return;
    
    self.alertViewState = AlertViewStateWillAppear;
    _cancelled_block_ = nil;
    btnCancel.hidden = YES;
    
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

- (void)btnCancelPressed:(id)sender {
    if(_cancelled_block_ != NULL
            && _cancelled_block_ != nil) {
        _cancelled_block_();
    }
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
    _cancelled_block_ = nil;
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
            btnCancel.hidden = YES;
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

- (void)setMessage:(NSString *)message forType:(AlertViewType)type showCancellButton:(BOOL)showCancelButton {
    btnCancel.hidden = !showCancelButton;
    [self setMessage:message forType:type];
}

- (UIWindow *)lastWindow {
    NSArray *windows = [UIApplication sharedApplication].windows;
    return [windows objectAtIndex:windows.count - 1];
}

@end
