//
//  XXDrawerViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/2/13.
//  Copyright (c) 2013 zhaoyang. All rights reserved.
//

#import "XXDrawerViewController.h"
#import "UIDevice+SystemVersion.h"

#define CENTER_VIEW_TAG        3900

#define BLACK_MASK_VIEW_TAG    2900
#define BLACK_MASK_VIEW_ALPHA  0.6
#define BLACK_BOARD_SCALE      0.95

@interface XXDrawerViewController ()

@end

@implementation XXDrawerViewController {
    UIView *blackLeftMaskView;
    UIView *blackRightMaskView;
    UIView *lockView;
    UIView *blackBoard;
    CGFloat lastedMainViewCenterX;
    CGFloat screenCenterY;
    BOOL leftViewIsAboveOnRightView;
    UITapGestureRecognizer *tapForMainViewStateHide;
    UIPanGestureRecognizer *panForMainViewStateHide;
    UIPanGestureRecognizer *panGesture;
    NSString *intentionDirection;
    BOOL leftTransitionHasReset;
    BOOL rightTransitionHasReset;
}

@synthesize leftView;
@synthesize rightView;
@synthesize mainView;
@synthesize centerView = _centerView_;
@synthesize rightViewCenterX;
@synthesize leftViewCenterX;
@synthesize leftViewVisibleWidth;
@synthesize rightViewVisibleWidth;
@synthesize scrollView;
@synthesize panFromScrollViewFirstPage;
@synthesize panFromScrollViewLastPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initialDrawerViewController {
    //20 is the status bar height
    if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
        screenCenterY = ([UIScreen mainScreen].bounds.size.height) / 2;
    } else {
        screenCenterY = ([UIScreen mainScreen].bounds.size.height - 20) / 2;
    }
    
    self.view.backgroundColor = [UIColor clearColor];
    
    if(blackLeftMaskView == nil) {
        blackLeftMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, screenCenterY * 2)];
        blackLeftMaskView.backgroundColor = [UIColor blackColor];
        blackLeftMaskView.tag = BLACK_MASK_VIEW_TAG;
        blackLeftMaskView.alpha = 0.4;
    }
    
    if(blackRightMaskView == nil) {
        blackRightMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, screenCenterY * 2)];
        blackRightMaskView.backgroundColor = [UIColor blackColor];
        blackRightMaskView.tag = BLACK_MASK_VIEW_TAG;
        blackRightMaskView.alpha = 0.4;
    }
    
    if(self.rightView != nil) {
        [self.rightView addSubview:blackRightMaskView];
        [self.view addSubview:self.rightView];
    }
    
    if(blackBoard == nil) {
        blackBoard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, screenCenterY * 2)];
        blackBoard.backgroundColor = [UIColor blackColor];
        [self.view addSubview:blackBoard];
    }
    
    if(self.leftView != nil) {
        [self.leftView addSubview:blackLeftMaskView];
        [self.view addSubview:self.leftView];
    }
    
    if(self.mainView == nil) {
        /* Create Main View */
        mainView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.mainView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.mainView];
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureForMainViewStateNormal:)];
        panGesture.delaysTouchesBegan = NO;
        [self.mainView addGestureRecognizer:panGesture];
    }
    
    /* Very funny ... haha ~ */
    if(self.centerView != nil) {
        self.centerView = self.centerView;
    }
    
    if(self.leftViewCenterX == 0) {
        self.leftViewCenterX = 110;
    }
    
    if(self.rightViewCenterX == 0) {
        self.rightViewCenterX = 190;
    }
    
    if(self.showDrawerMaxTrasitionX == 0) {
        self.showDrawerMaxTrasitionX = 80;
    }
    
    if(self.leftViewVisibleWidth == 0) {
        self.leftViewVisibleWidth = 220;
    }
    
    if(self.rightViewVisibleWidth == 0) {
        self.rightViewVisibleWidth = 260;
    }
    
    if(tapForMainViewStateHide == nil) {
        tapForMainViewStateHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureForMainViewStateHide:)];
    }
    
    if(panForMainViewStateHide == nil) {
        panForMainViewStateHide = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureForMainViewStateHide:)];
    }
    
    if(lockView == nil) {
        lockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, screenCenterY * 2)];
        lockView.backgroundColor = [UIColor clearColor];
        [lockView addGestureRecognizer:tapForMainViewStateHide];
        [lockView addGestureRecognizer:panForMainViewStateHide];
    }
    
    lastedMainViewCenterX = 160;
    leftViewIsAboveOnRightView = YES;
    self.leftViewEnable = YES;
    self.rightViewEnable = YES;
}

#pragma mark -
#pragma mark Gesture

- (UIPanGestureRecognizer *)getPanGesture {
    return panGesture;
}

- (void)handlePanGestureForMainViewStateNormal:(UIPanGestureRecognizer *)gesture {
    if(gesture !=  panGesture) return;
    CGPoint translation = [gesture translationInView:self.mainView];
    
    if(gesture.state == UIGestureRecognizerStateBegan) {
        lastedMainViewCenterX = self.mainView.center.x;
        intentionDirection = @"";
    }
    
    //dragging main view
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateBegan) {
        if(self.panFromScrollViewFirstPage) {
            if(translation.x > 0 && self.scrollView != nil) {
                if([@"" isEqualToString:intentionDirection]) {
                    intentionDirection = @"right";
                }
                if([@"left" isEqualToString:intentionDirection]) {
                    self.scrollView.scrollEnabled = YES;
                    [self moveMainViewToCenter:CGPointMake(160, screenCenterY)];
                    return;
                } else {
                    self.scrollView.scrollEnabled = NO;
                }
            } else if(self.scrollView.scrollEnabled) {
                if([@"" isEqualToString:intentionDirection]) {
                    intentionDirection = @"left";
                }
                if([@"left" isEqualToString:intentionDirection]) {
                    self.scrollView.scrollEnabled = YES;
                    [self moveMainViewToCenter:CGPointMake(160, screenCenterY)];
                    return;
                } else {
                    self.scrollView.scrollEnabled = NO;
                }
            }
        } else if(self.panFromScrollViewLastPage) {
            if(translation.x < 0 && self.scrollView != nil) {
                if([@"" isEqualToString:intentionDirection]) {
                    intentionDirection = @"left";
                }
                if([@"right" isEqualToString:intentionDirection]) {
                    self.scrollView.scrollEnabled = YES;
                    [self moveMainViewToCenter:CGPointMake(160, screenCenterY)];
                    return;
                } else {
                    self.scrollView.scrollEnabled = NO;
                }
            } else if (self.scrollView.scrollEnabled){
                if([@"" isEqualToString:intentionDirection]) {
                    intentionDirection = @"right";
                }
                if([@"right" isEqualToString:intentionDirection]) {
                    self.scrollView.scrollEnabled = YES;
                    [self moveMainViewToCenter:CGPointMake(160, screenCenterY)];
                    return;
                } else {
                    self.scrollView.scrollEnabled = NO;
                }
            }
        }
        if(translation.x > 0) {
            if(leftView == nil || !self.leftViewEnable) {
                [self showCenterView:NO];
                [gesture setTranslation:CGPointMake(0, 0) inView:self.mainView];
                return;
            }
            if(!leftViewIsAboveOnRightView && rightView != nil) [self leftViewToTopLevel];
        } else if(translation.x < 0) {
            if(rightView == nil || !self.rightViewEnable) {
                [self showCenterView:NO];
                [gesture setTranslation:CGPointMake(0, 0) inView:self.mainView];
                return;
            }
            if(leftViewIsAboveOnRightView && leftView != nil) [self rightViewToTopLevel];
        }
        
        CGFloat maxTransX = lastedMainViewCenterX + translation.x;
        if(maxTransX > 160 + self.leftViewVisibleWidth) {
            maxTransX = 160 + self.leftViewVisibleWidth;
            [gesture setTranslation:CGPointMake(self.leftViewVisibleWidth, 0) inView:self.mainView];
        } else if(maxTransX < 160 - self.rightViewVisibleWidth) {
            maxTransX = 160 - self.rightViewVisibleWidth;
            [gesture setTranslation:CGPointMake(0 - self.rightViewVisibleWidth, 0) inView:self.mainView];
        }
        
        CGPoint center = self.mainView.center;
        [self moveMainViewToCenter:CGPointMake(maxTransX, center.y)];
    } else if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        CGFloat mainViewX = self.mainView.frame.origin.x;
        //left view
        if(translation.x > 0) {
            //show
            if(mainViewX >= self.showDrawerMaxTrasitionX) {
                [self showLeftView];
            }
            //hide
            else {
                [self showCenterView:YES];
            }
        }
        //right view
        else if(translation.x < 0) {
            if(mainViewX < (0 - self.showDrawerMaxTrasitionX)) {
                [self showRightView];
            } else {
                [self showCenterView:YES];
            }
        }
        lastedMainViewCenterX = self.mainView.center.x;
    }
}

- (void)handleTapGestureForMainViewStateHide:(UITapGestureRecognizer *)gesture {
    [self showCenterView:YES];
}

- (void)handlePanGestureForMainViewStateHide:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:lockView];
    if(gesture.state == UIGestureRecognizerStateBegan) {
        lastedMainViewCenterX = self.mainView.center.x;
    }
    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateBegan) {
        CGFloat mainViewX = self.mainView.frame.origin.x;
        if(mainViewX > 0 && (lastedMainViewCenterX + translation.x) <= 160) {
            [self moveMainViewToCenter:CGPointMake(160, screenCenterY)];
            [gesture setTranslation:CGPointMake(0, 0) inView:lockView];
            leftTransitionHasReset = YES;
            return;
        } else if(mainViewX < 0 && (lastedMainViewCenterX + translation.x) >= 160) {
            [self moveMainViewToCenter:CGPointMake(160, screenCenterY)];
            [gesture setTranslation:CGPointMake(0, 0) inView:lockView];
            rightTransitionHasReset = YES;
            return;
        } else if(mainViewX == 0) {
            //main view is in center, but gesture are not canncelled now
            CGFloat lastedMainViewX = lastedMainViewCenterX - 160;
            if(lastedMainViewX > 0) {
                // hide left view
                // if direction is to left return
                if(translation.x <= 0) {
                    //lastedMainViewCenterX = self.mainView.center.x;
                    [gesture setTranslation:CGPointMake(0, 0) inView:lockView];
                    return;
                }
                lastedMainViewCenterX = self.mainView.center.x + translation.x;
            } else if(lastedMainViewX < 0) {
                // hide right view
                // if direction is to right return
                if(translation.x >= 0) {
                    [gesture setTranslation:CGPointMake(0, 0) inView:lockView];
                    return;
                }
                lastedMainViewCenterX = self.mainView.center.x + translation.x;
            }
        }
        
        CGFloat maxTransX = lastedMainViewCenterX + translation.x;
        
        if(maxTransX > 160 + self.leftViewVisibleWidth) {
            maxTransX = 160 + self.leftViewVisibleWidth;
            if(leftTransitionHasReset) {
                [gesture setTranslation:CGPointMake(self.leftViewVisibleWidth, 0) inView:lockView];
            } else {
                [gesture setTranslation:CGPointMake(0, 0) inView:lockView];
            }
        } else if(maxTransX < 160 - self.rightViewVisibleWidth) {
            maxTransX = 160 - self.rightViewVisibleWidth;
            if(rightTransitionHasReset) {
                [gesture setTranslation:CGPointMake(0 - self.rightViewVisibleWidth, 0) inView:lockView];
            } else {
                [gesture setTranslation:CGPointMake(0, 0) inView:lockView];
            }
        }
        
        [self moveMainViewToCenter:CGPointMake(maxTransX, self.mainView.center.y)];
        
    } else if(gesture.state == UIGestureRecognizerStateEnded) {
        leftTransitionHasReset = NO;
        rightTransitionHasReset = NO;
        CGFloat mainViewX = self.mainView.frame.origin.x;
        if(mainViewX > 0) {
            if(mainViewX <= self.leftViewCenterX) {
                [self showCenterView:YES];
            } else {
                [self showLeftView];
            }
        } else if(mainViewX < 0){
            if((mainViewX + 320) >= self.rightViewCenterX) {
                [self showCenterView:YES];
            } else {
                [self showRightView];
            }
        } else {
            [self showCenterView:YES];
        }
    }
}

#pragma mark -
#pragma mark Public methods

- (void)showLeftView {
    if(self.leftView == nil) return;
    if(self.mainView != nil) {
        self.mainView.backgroundColor = [UIColor clearColor];
    }
    if(!leftViewIsAboveOnRightView && leftView && rightView) [self leftViewToTopLevel];
    [UIView animateWithDuration:0.3 animations:^{
        [self moveMainViewToCenter:CGPointMake(160 + self.leftViewVisibleWidth, screenCenterY)];
    } completion:^(BOOL finished) {
        [self.mainView addSubview:lockView];
        self.panFromScrollViewFirstPage = NO;
        self.panFromScrollViewLastPage = NO;
        self.mainView.backgroundColor = [UIColor whiteColor];
        UIView *blackMaskView = [self.leftView viewWithTag:BLACK_MASK_VIEW_TAG];
        if(blackMaskView) {
            [blackMaskView removeFromSuperview];
        }
    }];
}

- (void)showCenterView:(BOOL)animate {
    if(self.mainView == nil) return;
    if(!(self.panFromScrollViewFirstPage && [intentionDirection isEqualToString:@"left"])
       && !(self.panFromScrollViewLastPage && [intentionDirection isEqualToString:@"right"])) {
        self.mainView.backgroundColor = [UIColor clearColor];
    }
    if(animate) {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveMainViewToCenter:CGPointMake(160, screenCenterY)];
        } completion:^(BOOL finished) {
            [self afterShowMainView];
        }];
    } else {
        [self moveMainViewToCenter:CGPointMake(160, screenCenterY)];
        [self afterShowMainView];
    }
}

- (void)afterShowMainView {
    if(self.scrollView != nil) self.scrollView.scrollEnabled = YES;
    self.panFromScrollViewFirstPage = NO;
    self.panFromScrollViewLastPage = NO;
    if(lockView.superview != nil) {
        [lockView removeFromSuperview];
    }
    self.mainView.backgroundColor = [UIColor whiteColor];
}

- (void)showRightView {
    if(self.rightView == nil) return;
    if(self.mainView != nil) {
        self.mainView.backgroundColor = [UIColor clearColor];
    }
    if(leftViewIsAboveOnRightView && leftView && rightView) [self rightViewToTopLevel];
    [UIView animateWithDuration:0.3 animations:^{
        [self moveMainViewToCenter:CGPointMake(160 - self.rightViewVisibleWidth, screenCenterY)];
    } completion:^(BOOL finished) {
        [self.mainView addSubview:lockView];
        self.panFromScrollViewFirstPage = NO;
        self.panFromScrollViewLastPage = NO;
        self.mainView.backgroundColor = [UIColor whiteColor];
        
        UIView *blackMaskView = [self.rightView viewWithTag:BLACK_MASK_VIEW_TAG];
        if(blackMaskView) {
            [blackMaskView removeFromSuperview];
        }
    }];
}

- (void)leftViewToTopLevel {
    if(!leftViewIsAboveOnRightView) {
        [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:2];
        leftViewIsAboveOnRightView = YES;
    }
}

- (void)rightViewToTopLevel {
    if(leftViewIsAboveOnRightView) {
        if(leftView == nil) {
            [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        } else {
            [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:2];
        }
        leftViewIsAboveOnRightView = NO;
    }
}

- (void)moveMainViewToCenter:(CGPoint)center {
    CGFloat preX = self.mainView.center.x - 160;
    CGFloat intentionX = center.x - self.mainView.center.x;
    CGFloat toX = center.x - 160;
    if(intentionX == 0) return;
    if(toX < 0) {
        [self addBlackMaskViewForDrawerViewIfNeed];
        [self rightViewMoving:toX];
    } else if(toX > 0) {
        [self addBlackMaskViewForDrawerViewIfNeed];
        [self leftViewMoving:toX];
    } else {
        if(preX == 0) return;
        [self addBlackMaskViewForDrawerViewIfNeed];
        if(preX > 0) {
            [self leftViewMoving:toX];
        } else {
            [self rightViewMoving:toX];
        }
    }
    self.mainView.center = center;
}

- (void)leftViewMoving:(CGFloat)x {
    UIView *view = [self.leftView viewWithTag:BLACK_MASK_VIEW_TAG];
    if(view != nil) {
        if(x >= self.leftViewVisibleWidth) {
            view.alpha = 0;
            self.leftView.transform = CGAffineTransformMakeScale(1, 1);
        } else if(x <= 0) {
            view.alpha = BLACK_MASK_VIEW_ALPHA;
            self.leftView.transform = CGAffineTransformMakeScale(BLACK_BOARD_SCALE, BLACK_BOARD_SCALE);
        } else {
            view.alpha = BLACK_MASK_VIEW_ALPHA - ((x * BLACK_MASK_VIEW_ALPHA) / self.leftViewVisibleWidth);
            CGFloat scale = ((1 - BLACK_BOARD_SCALE) * x) / self.leftViewVisibleWidth + BLACK_BOARD_SCALE;
            self.leftView.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
}

- (void)rightViewMoving:(CGFloat)x {
    UIView *view = [self.rightView viewWithTag:BLACK_MASK_VIEW_TAG];
    if(view != nil) {
        if((0-x) >= self.rightViewVisibleWidth) {
            view.alpha = 0;
            self.rightView.transform = CGAffineTransformMakeScale(1, 1);
        } else if(x >= 0) {
            view.alpha = BLACK_MASK_VIEW_ALPHA;
            self.rightView.transform = CGAffineTransformMakeScale(BLACK_BOARD_SCALE, BLACK_BOARD_SCALE);
        } else {
            view.alpha = BLACK_MASK_VIEW_ALPHA - (((0 - x) * BLACK_MASK_VIEW_ALPHA) / self.rightViewVisibleWidth);
            CGFloat scale = ((1 - BLACK_BOARD_SCALE) * (0 - x)) / self.rightViewVisibleWidth + BLACK_BOARD_SCALE;
            self.rightView.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
}

- (void)addBlackMaskViewForDrawerViewIfNeed {
    if(self.rightView != nil) {
        UIView *view = [self.rightView viewWithTag:BLACK_MASK_VIEW_TAG];
        if(view == nil) {
            [self.rightView addSubview:blackRightMaskView];
        }
    }
    if(self.leftView != nil) {
        UIView *view = [self.leftView viewWithTag:BLACK_MASK_VIEW_TAG];
        if(view == nil) {
            [self.leftView addSubview:blackLeftMaskView];
        }
    }
}

#pragma mark -
#pragma mark getter and setters

- (void)setCenterView:(UIView *)centerView {
    _centerView_ = centerView;
    if(self.mainView != nil) {
        UIView *v = [self.mainView viewWithTag:CENTER_VIEW_TAG];
        if(v != nil) {
            [v removeFromSuperview];
        }
        if(_centerView_ != nil) {
            _centerView_.tag = CENTER_VIEW_TAG;
            [self.mainView addSubview:_centerView_];
        }
    }
}

#pragma mark -
#pragma Gesture recognizer delegate

- (void)disableGestureForDrawerView {
    panGesture.enabled = NO;
}

- (void)enableGestureForDrawerView {
    panGesture.enabled = YES;
}

@end
