//
// Created by Zhao yang on 3/27/14.
//

#import "XXPopupView.h"

@implementation XXPopupView {
    CALayer *containerLayer;
    CALayer *backgroundLayer;

    UIView *maskView;
}

@synthesize state;
@synthesize animationDuration;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.state = XXPopupViewStateClosed;
        self.animationDuration = 0.3f;

        maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.5f;
        UITapGestureRecognizer *tapGestureRecognizer =
                [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
        [maskView addGestureRecognizer:tapGestureRecognizer];

        backgroundLayer = [CALayer layer];
        backgroundLayer.frame = [UIScreen mainScreen].bounds;
        backgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    }
    return self;
}

- (void)showInView:(UIView *)view { // completion:(void (^)(void))completion {
    if(XXPopupViewStateClosed != self.state) return;
    self.state = XXPopupViewStateOpening;

    if(view == nil || view.superview == nil) return;

    // Remember or Reset the container view
    containerLayer = view.layer;

    // Container Background Layer
    [containerLayer.superlayer insertSublayer:backgroundLayer below:containerLayer];
    // Container Mask View
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    // Popup View
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    CATransform3D fromScaleTransform = CATransform3DMakeScale(1.0, 1.0, 1.0);
    CATransform3D toScaleTransform = CATransform3DMakeScale(0.9, 0.9, 1.0);

    float fromOpacity = 0.0f;
    float toOpacity = 0.5f;

    CGPoint fromPosition = self.layer.position;
    CGPoint toPosition = CGPointMake(fromPosition.x, self.layer.position.y - self.layer.bounds.size.height);

    [self doAnimationsWithCompletion:^{
        self.state = XXPopupViewStateOpened;
//            if(completion != nil) completion();
    }
                  fromScaleTransform:fromScaleTransform toScaleTransform:toScaleTransform
                         fromOpacity:fromOpacity toOpacity:toOpacity
                        fromPosition:fromPosition toPosition:toPosition inLayer:containerLayer];
}

- (void)closeView {
    if(XXPopupViewStateOpened != self.state) return;
    self.state = XXPopupViewStateClosing;

    CATransform3D fromScaleTransform = CATransform3DMakeScale(0.9, 0.9, 1.0);
    CATransform3D toScaleTransform = CATransform3DMakeScale(1.0, 1.0, 1.0);

    float fromOpacity = 0.5f;
    float toOpacity = 0.0f;

    CGPoint fromPosition = self.layer.position;
    CGPoint toPosition = CGPointMake(fromPosition.x, self.layer.position.y + self.layer.bounds.size.height);

    // clean up after do animations
    [self doAnimationsWithCompletion:^{
        if(maskView.superview != nil) {
            [maskView removeFromSuperview];
        }

        if(backgroundLayer.superlayer != nil) {
            [backgroundLayer removeFromSuperlayer];
        }

        if(self.superview != nil) {
            [self removeFromSuperview];
        }
        containerLayer = nil;
        self.state = XXPopupViewStateClosed;
    }
                  fromScaleTransform:fromScaleTransform toScaleTransform:toScaleTransform
                         fromOpacity:fromOpacity toOpacity:toOpacity
                        fromPosition:fromPosition toPosition:toPosition inLayer:containerLayer];
}

- (void)doAnimationsWithCompletion:(void (^)(void))completion
                fromScaleTransform:(CATransform3D)fromScaleTransform
                  toScaleTransform:(CATransform3D)toScaleTransform
                       fromOpacity:(float)fromOpacity toOpacity:(float)toOpacity
                      fromPosition:(CGPoint)fromPosition toPosition:(CGPoint)toPosition
                           inLayer:(CALayer *)layer {

    // Set Animation Completion Block
    [CATransaction setCompletionBlock:^{
        if(completion != nil) completion();
    }];

    [CATransaction begin];

    // create container view's scale animation
    CABasicAnimation *scaleViewAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleViewAnimation.fromValue = [NSValue valueWithCATransform3D:fromScaleTransform];
    scaleViewAnimation.toValue = [NSValue valueWithCATransform3D:toScaleTransform];
    scaleViewAnimation.duration = self.animationDuration;
    scaleViewAnimation.removedOnCompletion = YES;
    [layer addAnimation:scaleViewAnimation forKey:nil];

    // create mask view's opacity animation
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:fromOpacity];
    opacityAnimation.toValue = [NSNumber numberWithFloat:toOpacity];
    opacityAnimation.duration = self.animationDuration;
    opacityAnimation.removedOnCompletion = YES;
    [maskView.layer addAnimation:opacityAnimation forKey:nil];

    // create pop view's position animation
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = self.animationDuration;
    positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
    positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
    positionAnimation.removedOnCompletion = YES;
    [self.layer addAnimation:positionAnimation forKey:nil];

    [CATransaction commit];

    // Really Update Values
    layer.transform = toScaleTransform;
    maskView.layer.opacity = toOpacity;
    self.layer.position = toPosition;
}

@end