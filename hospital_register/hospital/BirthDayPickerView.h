//
//  BirthDayPickerView.h
//  hospital
//
//  Created by Zhao yang on 3/31/14.
//
//

#import "XXPopupView.h"

@protocol BirthDayPickerViewDelegate;

@interface BirthDayPickerView : XXPopupView

@property (nonatomic, weak) id<BirthDayPickerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame birthDay:(NSDate *)birthDay;

@end

@protocol BirthDayPickerViewDelegate<NSObject>

- (void)birthDayPickerView:(BirthDayPickerView *)birthDayPickerView didSelectDate:(NSDate *)date;

@end
