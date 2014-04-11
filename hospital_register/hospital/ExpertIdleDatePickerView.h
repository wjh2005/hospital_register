//
//  ExpertIdleDatePickerView.h
//  hospital
//
//  Created by Zhao yang on 3/27/14.
//
//

#import <UIKit/UIKit.h>
#import "ExpertsWrapper.h"
#import "XXPopupView.h"

@protocol ExpertIdleDatePickerViewDelegate;

@interface ExpertIdleDatePickerView : XXPopupView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id<ExpertIdleDatePickerViewDelegate> delegate;
@property (nonatomic) NSInteger defaultIdleDate;

- (instancetype)initWithFrame:(CGRect)frame expertsWrappers:(NSArray *)expertsWrappers;
- (void)refreshWithExpertsWrappers:(NSArray *)expertsWrappers;

@end

@protocol ExpertIdleDatePickerViewDelegate<NSObject>

@required

- (void)expertIdleDatePickerView:(ExpertIdleDatePickerView *)expertIdleDatePickerView didSelectValue:(NSInteger)value title:(NSString *)title;

@end