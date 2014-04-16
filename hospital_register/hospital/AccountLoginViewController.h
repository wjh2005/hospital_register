//
//  AccountLoginViewController.h
//  hospital
//
//  Created by Zhao yang on 4/15/14.
//
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, LoginState) {
    LoginStateUnStart,
    LoginStateLogging,
    LoginStateCancelling,
};

@interface AccountLoginViewController : BaseViewController<UITextFieldDelegate>

@property (nonatomic) LoginState loginState;

@end
