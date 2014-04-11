//
// Created by Zhao yang on 3/18/14.
//

#import <Foundation/Foundation.h>
#import "GenderPickerViewController.h"
#import "TextModifyViewController.h"
#import "BirthDayPickerView.h"

@interface PersonalCenterViewController :
        NavigationViewController<UITableViewDelegate, UITableViewDataSource, GenderPickerViewControllerDelegate, TextModifyViewControllerDelegate, BirthDayPickerViewDelegate>

@end