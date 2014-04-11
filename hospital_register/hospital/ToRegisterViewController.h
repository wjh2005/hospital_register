//
// Created by Zhao yang on 3/15/14.
//

#import <Foundation/Foundation.h>
#import "NavigationViewController.h"
#import "OutpatientDepartmentPickerViewController.h"
#import "OutpatientDepartmentExpertPickerViewController.h"

@interface ToRegisterViewController : NavigationViewController
        <OutpatientDepartmentPickerDelegate, OutpatientDepartmentExpertPickerDelegate>

@end