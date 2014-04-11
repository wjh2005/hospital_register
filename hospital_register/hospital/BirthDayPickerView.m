//
//  BirthDayPickerView.m
//  hospital
//
//  Created by Zhao yang on 3/31/14.
//
//

#import "BirthDayPickerView.h"
#import "UIDevice+SystemVersion.h"
#import "UIColor+MoreColor.h"

@implementation BirthDayPickerView {
    UIDatePicker *datePicker;
    
    NSDate *defaultDate;
}

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame birthDay:(NSDate *)birthDay {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, 216 + 40)];
    if (self) {
        defaultDate = birthDay;
        // Initialization code
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, 216 + 40)];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    datePicker = [[UIDatePicker alloc] initWithFrame:
                      CGRectMake(0, 40, self.bounds.size.width, 216)];
    datePicker.timeZone = [NSTimeZone localTimeZone];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    datePicker.minimumDate = [dateFormatter dateFromString:@"1900-01-01"];
    datePicker.backgroundColor = [UIColor whiteColor];
    
    if(defaultDate != nil) {
        [datePicker setDate:defaultDate animated:NO];
        defaultDate = nil;
    }
    
    [self addSubview:datePicker];
}

- (void)btnConfirmPressed:(id)sender {
    if(self.delegate != nil
       && [self.delegate respondsToSelector:@selector(birthDayPickerView:didSelectDate:)]) {
        [self.delegate birthDayPickerView:self didSelectDate:datePicker.date];
    }
    [self closeView];
}

@end
