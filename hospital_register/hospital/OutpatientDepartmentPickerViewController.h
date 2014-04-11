//
// Created by Zhao yang on 3/15/14.
//

#import <Foundation/Foundation.h>
#import "ToPortalNavigationViewController.h"
#import "Department.h"

@protocol OutpatientDepartmentPickerDelegate;

@interface OutpatientDepartmentPickerViewController : ToPortalNavigationViewController<
        UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) id<OutpatientDepartmentPickerDelegate> delegate;
@property (nonatomic) DepartmentType departmentType;

- (instancetype)initWithDepartmentType:(DepartmentType)departmentType;

@end

@protocol OutpatientDepartmentPickerDelegate <NSObject>

@required

- (void)outpatientDepartmentPicker:
        (OutpatientDepartmentPickerViewController *)outpatientDepartmentPicker didSelectDepartment:(Department *)department;

@end