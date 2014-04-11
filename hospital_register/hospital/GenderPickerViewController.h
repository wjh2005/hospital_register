//
// Created by Zhao yang on 3/31/14.
//

#import <Foundation/Foundation.h>
#import "NavigationViewController.h"
#import "Account.h"

@protocol GenderPickerViewControllerDelegate;

@interface GenderPickerViewController : NavigationViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) Gender gender;
@property (nonatomic, weak) id<GenderPickerViewControllerDelegate> delegate;

- (instancetype)initWithGender:(Gender)gender;

@end


@protocol GenderPickerViewControllerDelegate<NSObject>

- (void)genderPickerViewController:(GenderPickerViewController *)genderPickerViewController didSelectGender:(Gender)gender;

@end