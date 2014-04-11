//
//  XXDrawerViewController.h
//  SmartHome
//
//  Created by Zhao yang on 8/2/13.
//  Copyright (c) 2013 zhaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface XXDrawerViewController : UIViewController<UIScrollViewDelegate>

@property (assign, nonatomic) CGFloat leftViewCenterX;
@property (assign, nonatomic) CGFloat rightViewCenterX;
@property (assign, nonatomic) CGFloat showDrawerMaxTrasitionX;
@property (assign, nonatomic) CGFloat leftViewVisibleWidth;
@property (assign, nonatomic) CGFloat rightViewVisibleWidth;
@property (assign, nonatomic) BOOL panFromScrollViewFirstPage;
@property (assign, nonatomic) BOOL panFromScrollViewLastPage;
@property (assign, nonatomic) BOOL rightViewEnable;
@property (assign, nonatomic) BOOL leftViewEnable;
@property (strong, nonatomic, readonly) UIView *mainView;
@property (strong, nonatomic) UIView *centerView;
@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) UIView *rightView;
@property (strong, nonatomic) UIScrollView *scrollView;

- (void)showRightView;
- (void)showCenterView:(BOOL)animate;
- (void)showLeftView;

- (void)disableGestureForDrawerView;
- (void)enableGestureForDrawerView;

- (void)initialDrawerViewController;

- (UIPanGestureRecognizer *)getPanGesture;

@end
