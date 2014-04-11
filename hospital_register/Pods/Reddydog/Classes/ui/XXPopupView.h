//
// Created by Zhao yang on 3/27/14.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , XXPopupViewState) {
    XXPopupViewStateClosed,
    XXPopupViewStateClosing,
    XXPopupViewStateOpening,
    XXPopupViewStateOpened,
};

@interface XXPopupView : UIView

@property (nonatomic) XXPopupViewState state;
@property (nonatomic) NSTimeInterval animationDuration;

- (void)showInView:(UIView *)view; // completion:(void (^)(void))completion;
- (void)closeView;

@end