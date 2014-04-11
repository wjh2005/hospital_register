//
// Created by Zhao yang on 3/17/14.
//

#import <Foundation/Foundation.h>
#import "ToPortalNavigationViewController.h"
#import "Expert.h"

@protocol ExpertPickerDelegate;

@interface ExpertPickerViewController :
        ToPortalNavigationViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) id<ExpertPickerDelegate> delegate;

@end

@protocol ExpertPickerDelegate <NSObject>

@required

- (void)expertPicker:(ExpertPickerViewController *)expertPickerViewController
     didSelectExpert:(Expert *)expert;

@end