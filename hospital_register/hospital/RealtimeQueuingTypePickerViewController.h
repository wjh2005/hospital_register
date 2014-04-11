//
// Created by Zhao yang on 3/17/14.
//

#import <Foundation/Foundation.h>
#import "NavigationViewController.h"
#import "ExpertPickerViewController.h"
#import "OutpatientDepartmentPickerViewController.h"

@interface RealtimeQueuingTypePickerViewController :
    NavigationViewController<OutpatientDepartmentPickerDelegate, ExpertPickerDelegate>

@end