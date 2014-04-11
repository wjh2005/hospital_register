//
//  ExpertIdleDatePickerView.m
//  hospital
//
//  Created by Zhao yang on 3/27/14.
//
//

#import "ExpertIdleDatePickerView.h"
#import "UIColor+MoreColor.h"
#import "ChineseWeekdayUtils.h"
#import "UIDevice+SystemVersion.h"
#import "DateTitleValue.h"

@implementation ExpertIdleDatePickerView {
    UIPickerView *datePickerView;
    NSDateFormatter *dateFormatter;

    NSMutableArray *titleValueItems;
}

@synthesize delegate;
@synthesize defaultIdleDate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, 216 + 40)];
    if (self) {
        // Initialization code
        [self initDefaults];
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame expertsWrappers:(NSArray *)expertsWrappers {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, 216 + 40)];
    if(self) {
        [self initDefaults];
        [self initUI];
        [self refreshWithExpertsWrappers:expertsWrappers];
    }
    return self;
}

- (void)initDefaults {
    defaultIdleDate = -1;
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    titleValueItems = [NSMutableArray array];
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

- (void)btnConfirmPressed:(id)sender {
    if(self.delegate != nil
            && [self.delegate respondsToSelector:@selector(expertIdleDatePickerView:didSelectValue:title:)]) {
        NSInteger selectedIndex =[datePickerView selectedRowInComponent:0];
        DateTitleValue *tv = [titleValueItems objectAtIndex:selectedIndex];
        [self.delegate expertIdleDatePickerView:self didSelectValue:tv.weekDayValue title:tv.dateTitle];
    }
    [self closeView];
}

- (void)refreshWithExpertsWrappers:(NSArray *)expertsWrappers {
    [titleValueItems removeAllObjects];

    DateTitleValue *withinAWeek = [[DateTitleValue alloc] init];
    withinAWeek.dateTitle = NSLocalizedString(@"within_a_week", @"");
    withinAWeek.weekDayValue = -1;
    [titleValueItems addObject:withinAWeek];

    if(expertsWrappers != nil) {
        for(int i=0; i<expertsWrappers.count; i++) {
            ExpertsWrapper *ew = [expertsWrappers objectAtIndex:i];
            if(ew.experts != nil && ew.experts.count > 0) {
                NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:ew.date];
                NSInteger chineseWeekDay = dateComponents.weekday;
                if(chineseWeekDay == 1) {
                    chineseWeekDay = 7;
                } else {
                    chineseWeekDay--;
                }
                NSString *dateString = [NSString
                        stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:ew.date], [ChineseWeekdayUtils chineseWeekDayWithWeekdayNumber:chineseWeekDay]];

                DateTitleValue *item = [[DateTitleValue alloc] init];
                item.dateTitle = dateString;
                item.weekDayValue = 1 << chineseWeekDay;
                [titleValueItems addObject:item];
            }
        }
    }

    [datePickerView reloadAllComponents];
}

- (void)showInView:(UIView *)view {
    if(self.defaultIdleDate != -1 && titleValueItems != nil) {
        for(int i=0; i< titleValueItems.count; i++) {
            DateTitleValue *tv = [titleValueItems objectAtIndex:i];
            if(tv.weekDayValue == self.defaultIdleDate) {
                [datePickerView selectRow:i inComponent:0 animated:NO];
                break;
            }
        }
    }
    [super showInView:view];
}

#pragma mark -
#pragma mark Picker View Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return titleValueItems.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 210;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 36;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    // Create reuse view
    if(view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, 36)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 210, 30)];
        [view addSubview:titleLabel];
        if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
            titleLabel.font = [UIFont systemFontOfSize:20.f];
        } else {
            titleLabel.font = [UIFont boldSystemFontOfSize:19.f];
        }
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.tag = 222;
    }

    // Set dateTitle for each item
    UILabel *lblTitle = (UILabel *)[view viewWithTag:222];
    if(lblTitle != nil) {
        DateTitleValue *titleValue = [titleValueItems objectAtIndex:row];
        lblTitle.text = titleValue.dateTitle;
    }

    return view;
}

@end
