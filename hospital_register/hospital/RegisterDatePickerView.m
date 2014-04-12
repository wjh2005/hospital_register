//
// Created by Zhao yang on 3/28/14.
//

#import "RegisterDatePickerView.h"
#import "UIDevice+SystemVersion.h"
#import "UIColor+MoreColor.h"
#import "ChineseWeekdayUtils.h"
#import "DateTitleValue.h"
#import "Configs.h"

@implementation RegisterDatePickerView {
    UIPickerView *datePickerView;
    NSMutableArray *dateTitleValueItems;

    ExpertIdleDate defaultSelectedExpertIdleDate;
    ExpertIdleTime defaultSelectedExpertIdleTime;
    NSDate *defaultSelectedDate;
}

@synthesize expert = _expert_;
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame date:(NSDate *)date idleTime:(ExpertIdleTime)idleTime {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, 216 + 40)];
    if(self) {
        defaultSelectedDate = date;
        defaultSelectedExpertIdleTime = idleTime;
        [self initDefaults];
        [self initUI];
        [self refresh];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame expert:(Expert *)expert
               expertIdleDate:(ExpertIdleDate)expertIdleDate expertIdleTime:(ExpertIdleTime)expertIdleTime {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, 216 + 40)];
    if(self) {
        self.expert = expert;
        defaultSelectedExpertIdleDate = expertIdleDate;
        defaultSelectedExpertIdleTime = expertIdleTime;
        [self initDefaults];
        [self initUI];
        [self refresh];
    }
    return self;
}

- (void)initDefaults {
}

- (void)initUI {
    // Create Date Picker Confirm View
    UIImageView *datePickerConfirmView = [[UIImageView alloc] initWithFrame:
            CGRectMake(0, 0, self.bounds.size.width, 40)];
    datePickerConfirmView.userInteractionEnabled = YES;
    if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
        datePickerConfirmView.backgroundColor = [UIColor appBackgroundGray];
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 160, 40)];
        lblTitle.textColor = [UIColor appFontDarkGray];
        lblTitle.text = NSLocalizedString(@"please_select", @"");
        lblTitle.font = [UIFont systemFontOfSize:18.f];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        [datePickerConfirmView addSubview:lblTitle];
    } else {
        datePickerConfirmView.image = [UIImage imageNamed:@"bg_picker_view"];
    }
    [self addSubview:datePickerConfirmView];

    if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
        UIButton *btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(260, 2, 60, 36)];
        [btnConfirm addTarget:self action:@selector(btnConfirmPressed:) forControlEvents:UIControlEventTouchUpInside];
        btnConfirm.titleLabel.font = [UIFont systemFontOfSize:16.f];
        btnConfirm.backgroundColor = [UIColor clearColor];
        [btnConfirm setTitle:NSLocalizedString(@"confirm", @"") forState:UIControlStateNormal];
        [btnConfirm setTitleColor:[UIColor ios7Blue] forState:UIControlStateNormal];
        [btnConfirm setTitleColor:[UIColor ios7HighlightedBlue] forState:UIControlStateHighlighted];
        [datePickerConfirmView addSubview:btnConfirm];

        UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, 60, 36)];
        [btnCancel addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        btnCancel.backgroundColor = [UIColor clearColor];
        btnCancel.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [btnCancel setTitle:NSLocalizedString(@"cancel", @"") forState:UIControlStateNormal];
        [btnCancel setTitleColor:[UIColor ios7Blue] forState:UIControlStateNormal];
        [btnCancel setTitleColor:[UIColor ios7HighlightedBlue] forState:UIControlStateHighlighted];
        [datePickerConfirmView addSubview:btnCancel];
    } else {
        UIButton *btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(267, 5, 48, 30)];
        [btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_picker_confirm"] forState:UIControlStateNormal];
        [btnConfirm addTarget:self action:@selector(btnConfirmPressed:) forControlEvents:UIControlEventTouchUpInside];
        [datePickerConfirmView addSubview:btnConfirm];
        
        UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 48, 30)];
        [btnCancel addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_picker_cancel"] forState:UIControlStateNormal];
        [datePickerConfirmView addSubview:btnCancel];
    }

    datePickerView = [[UIPickerView alloc] initWithFrame:
            CGRectMake(0, 40, self.bounds.size.width, 216)];
    datePickerView.backgroundColor = [UIColor whiteColor];
    datePickerView.delegate = self;
    datePickerView.dataSource = self;
    datePickerView.showsSelectionIndicator = YES;

    [self addSubview:datePickerView];
}

- (void)refresh {
    if(dateTitleValueItems == nil) dateTitleValueItems = [NSMutableArray array];
    [dateTitleValueItems removeAllObjects];

    NSInteger weekDayToday = [ChineseWeekdayUtils chineseWeekDayToday];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [Configs defaultConfigs].defaultTimeZone;
    dateFormatter.dateFormat = @"yyyy-MM-dd";

    NSInteger dateSelectedRowIndex = -1;
    NSInteger timeSelectedRowIndex = -1;

    for(int i=0; i<7; i++) {
        NSInteger weekDay = ((weekDayToday + i) > 7) ? (weekDayToday + i - 7) : (weekDayToday + i);
        DateTitleValue *dateTitleValue = [[DateTitleValue alloc] init];
        dateTitleValue.date = [NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * i];
        dateTitleValue.dateTitle = [NSString stringWithFormat:@"%@ %@",
                        [dateFormatter stringFromDate:dateTitleValue.date], [ChineseWeekdayUtils chineseWeekDayWithWeekdayNumber:weekDay]];

        if(self.expert != nil) {
            ExpertIdleDate idleDate = 1 << (weekDay - 1);
            ExpertIdleTime idleTime = [self.expert expertIdleTimeFor:idleDate];
            if(ExpertIdleTimeNone == idleTime) continue;
            if(idleDate == defaultSelectedExpertIdleDate) {
                dateSelectedRowIndex = dateTitleValueItems.count;
                if(ExpertIdleTimeMorningAndAfternoon == idleTime && ExpertIdleTimeAfternoon == defaultSelectedExpertIdleTime) {
                    timeSelectedRowIndex = 1;
                } else {
                    timeSelectedRowIndex = 0;
                }
            }
            dateTitleValue.weekDayValue = idleDate;
            dateTitleValue.timeValue = idleTime;
        } else {
            if(defaultSelectedDate != nil) {
                if([[dateFormatter stringFromDate:defaultSelectedDate] isEqualToString:
                   [dateFormatter stringFromDate:dateTitleValue.date]]) {
                    dateSelectedRowIndex = i;
                }
            }
            if(ExpertIdleTimeMorning == defaultSelectedExpertIdleTime) {
                timeSelectedRowIndex = 0;
            } else if(ExpertIdleTimeAfternoon == defaultSelectedExpertIdleTime) {
                timeSelectedRowIndex = 1;
            } else if(ExpertIdleTimeEvening == defaultSelectedExpertIdleTime) {
                timeSelectedRowIndex = 2;
            }
        }
        [dateTitleValueItems addObject:dateTitleValue];
    }
    [datePickerView reloadAllComponents];

    if(dateSelectedRowIndex != -1) {
        [datePickerView selectRow:dateSelectedRowIndex inComponent:0 animated:NO];
        [self pickerView:datePickerView didSelectRow:dateSelectedRowIndex inComponent:0];
        if(timeSelectedRowIndex != -1) {
            [datePickerView selectRow:timeSelectedRowIndex inComponent:1 animated:NO];
        }
    }
}

#pragma mark -
#pragma mark UI Event

- (void)btnConfirmPressed:(id)sender {
    if(self.delegate != nil
       && [self.delegate respondsToSelector:@selector(registerDatePickerView:didSelectDate:expertIdleTime:)]) {
        
        NSInteger dateSelectedRow = [datePickerView selectedRowInComponent:0];
        DateTitleValue *dateTitleValue = [dateTitleValueItems objectAtIndex:dateSelectedRow];
        if(self.expert != nil) {
            ExpertIdleTime idleTime;
            NSInteger timeSelectedRow = [datePickerView selectedRowInComponent:1];
            if(timeSelectedRow == 0) {
                if(ExpertIdleTimeMorning == (dateTitleValue.timeValue & ExpertIdleTimeMorning)) {
                    idleTime = ExpertIdleTimeMorning;
                } else {
                    idleTime = ExpertIdleTimeAfternoon;
                }
            } else {
                idleTime = ExpertIdleTimeAfternoon;
            }
            [self.delegate registerDatePickerView:self didSelectDate:dateTitleValue.date expertIdleTime:idleTime];
        } else {
            NSInteger timeSelectedRow = [datePickerView selectedRowInComponent:1];
            ExpertIdleTime idleTime;
            if(timeSelectedRow == 0) {
                idleTime = ExpertIdleTimeMorning;
            } else if(timeSelectedRow == 1) {
                idleTime = ExpertIdleTimeAfternoon;
            } else {
                idleTime = ExpertIdleTimeEvening;
            }
            [self.delegate registerDatePickerView:self didSelectDate:dateTitleValue.date expertIdleTime:idleTime];
        }
    }
    [self closeView];
}

#pragma mark -
#pragma mark Picker View Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == 0) {
        return dateTitleValueItems == nil ? 0 : dateTitleValueItems.count;
    } else {
        if(self.expert == nil) return 3;
        NSInteger selectRow = [pickerView selectedRowInComponent:0];
        DateTitleValue *dateTitleValue = [dateTitleValueItems objectAtIndex:selectRow];
        return ExpertIdleTimeMorningAndAfternoon == dateTitleValue.timeValue ? 2 : 1;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return component == 0 ? 150 : 80;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 36;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {

    if(component == 0) {
        if(view == nil) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 36)];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 150, 30)];
            [view addSubview:titleLabel];
            if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
                titleLabel.font = [UIFont systemFontOfSize:16.f];
            } else {
                titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
            }
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.tag = 222;
        }
    } else {
        if(view == nil) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 36)];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 80, 30)];
            [view addSubview:titleLabel];
            if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
                titleLabel.font = [UIFont systemFontOfSize:16.f];
            } else {
                titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
            }
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.tag = 333;
        }
    }

    if(component == 0) {
        DateTitleValue *dateTitleValue = [dateTitleValueItems objectAtIndex:row];
        UILabel *lblTitle = (UILabel *)[view viewWithTag:222];
        lblTitle.text = dateTitleValue.dateTitle;
    } else {
        NSInteger selectRow = [pickerView selectedRowInComponent:0];
        DateTitleValue *dateTitleValue = [dateTitleValueItems objectAtIndex:selectRow];
        UILabel *lblTitle = (UILabel *)[view viewWithTag:333];
        
        if(self.expert == nil) {
            if(row == 0) {
                lblTitle.text = NSLocalizedString(@"morning", @"");
            } else if(row == 1) {
                lblTitle.text = NSLocalizedString(@"afternoon", @"");
            } else {
                lblTitle.text = NSLocalizedString(@"evening", @"");
            }
        } else {
            if(ExpertIdleTimeMorningAndAfternoon == dateTitleValue.timeValue) {
                if(row == 0) {
                    lblTitle.text = NSLocalizedString(@"morning", @"");
                } else {
                    lblTitle.text = NSLocalizedString(@"afternoon", @"");
                }
            } else {
                if(ExpertIdleTimeMorning == dateTitleValue.timeValue) {
                    lblTitle.text = NSLocalizedString(@"morning", @"");
                } else {
                    lblTitle.text = NSLocalizedString(@"afternoon", @"");
                }
            }
        }
    }

    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(component != 0) return;
    if(pickerView.numberOfComponents > 1) {
        [pickerView reloadComponent:1];
    }
}

@end