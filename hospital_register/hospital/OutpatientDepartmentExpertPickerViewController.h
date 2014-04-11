//
// Created by Zhao yang on 3/17/14.
//

#import <Foundation/Foundation.h>
#import "ToPortalNavigationViewController.h"
#import "ExpertsWrapper.h"
#import "Department.h"
#import "ExpertIdleDatePickerView.h"

@protocol OutpatientDepartmentExpertPickerDelegate;

@interface OutpatientDepartmentExpertPickerViewController :
        ToPortalNavigationViewController<UITableViewDataSource, UITableViewDelegate, ExpertIdleDatePickerViewDelegate>

@property (nonatomic, strong) Department *department;
@property (nonatomic, weak) id<OutpatientDepartmentExpertPickerDelegate> delegate;

- (id)initWithDepartment:(Department *)department;
- (void)refresh;

@end


@protocol OutpatientDepartmentExpertPickerDelegate<NSObject>

@required

- (void)outpatientDepartmentExpertPicker:
        (OutpatientDepartmentExpertPickerViewController *)outpatientDepartmentExpertPicker
        didSelectExpert:(Expert *)expert registerDate:(NSDate *)date;

@end