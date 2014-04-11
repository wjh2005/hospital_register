//
// Created by Zhao yang on 3/30/14.
//

#import <Foundation/Foundation.h>
#import "NavigationViewController.h"

typedef NS_ENUM(NSInteger, TextModifyViewType) {
    TextModifyViewTypeSingleLine,
    TextModifyViewTypeMultiLine,
};

@protocol TextModifyViewControllerDelegate;

@interface TextModifyViewController : NavigationViewController

@property (nonatomic) TextModifyViewType textModifyViewType;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSString *tips;
@property (nonatomic, strong) id userObject;
@property (nonatomic, weak) id<TextModifyViewControllerDelegate> delegate;

- (instancetype)initWithTextModifyViewType:(TextModifyViewType)textModifyViewType;

@end

@protocol TextModifyViewControllerDelegate<NSObject>

- (void)textModifyViewControllerDidConfirm:(TextModifyViewController *)textModifyViewController;

@end