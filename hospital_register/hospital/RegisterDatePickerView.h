//
// Created by Zhao yang on 3/28/14.
//

#import <Foundation/Foundation.h>
#import "XXPopupView.h"
#import "Expert.h"

@protocol RegisterDatePickerViewDelegate;

@interface RegisterDatePickerView : XXPopupView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id<RegisterDatePickerViewDelegate> delegate;
@property (nonatomic, strong) Expert *expert;

- (instancetype)initWithFrame:(CGRect)frame expert:(Expert *)expert
               expertIdleDate:(ExpertIdleDate)expertIdleDate expertIdleTime:(ExpertIdleTime)expertIdleTime;

- (instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date idleTime:(ExpertIdleTime)idleTime;

@end

@protocol RegisterDatePickerViewDelegate <NSObject>

- (void)registerDatePickerView:(RegisterDatePickerView *)registerDatePickerView didSelectDate:(NSDate *)date expertIdleTime:(ExpertIdleTime)expertIdleTime;

@end