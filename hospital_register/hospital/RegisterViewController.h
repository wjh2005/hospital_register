//
// Created by Zhao yang on 3/20/14.
//

#import <Foundation/Foundation.h>
#import "ToPortalNavigationViewController.h"
#import "RegisterDatePickerView.h"
#import "Expert.h"

@interface RegisterViewController :
        ToPortalNavigationViewController<UITableViewDelegate, UITableViewDataSource, RegisterDatePickerViewDelegate>

@property (nonatomic, strong) Expert *expert;
@property (nonatomic, strong) Department *department;

- (instancetype)initWithExpert:(Expert *)expert registerDate:(NSDate *)registerDate;
- (instancetype)initWithDepartment:(Department *)department;

@end