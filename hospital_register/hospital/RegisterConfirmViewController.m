//
// Created by Zhao yang on 3/21/14.
//

#import "RegisterConfirmViewController.h"
#import "PaperBackgroundView.h"
#import "Department.h"
#import "Account.h"

@implementation RegisterConfirmViewController {
}

@synthesize registerOrder = _registerOrder_;

- (id)initWithRegisterOrder:(RegisterOrder *)registerOrder {
    self = [super init];
    if(self) {
        self.registerOrder = registerOrder;
    }
    return self;
}


- (void)initUI {
    [super initUI];
    self.title = NSLocalizedString(@"register_order_confirm", @"");

    PaperBackgroundView *paperBackgroundView =
            [[PaperBackgroundView alloc] initWithFrame:CGRectMake(14, 0, 0, self.registerOrder.registerType == RegisterTypeExpert ? 390 : 360)];
    [self.view addSubview:paperBackgroundView];

    // Create Title View
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 150, 30)];
    lblTitle.center = CGPointMake(paperBackgroundView.bounds.size.width / 2, lblTitle.center.y);
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = NSLocalizedString(@"register_order", @"");
    lblTitle.font = [UIFont systemFontOfSize:18.f];
    lblTitle.textColor = [UIColor appFontGray];
    [paperBackgroundView addSubview:lblTitle];

    // Create Grid Table View
    NSInteger bodyEntryCount = self.registerOrder.registerType == RegisterTypeOutpatient ? 6 : 7;
    CGFloat bodyEntryHeight = 34;
    UIColor *lineColor = [UIColor colorWithRed:172.f / 255.f green:170.f / 255.f blue:150.f / 255.f alpha:1];
    UIView *bodyView = [[UIView alloc] initWithFrame:
            CGRectMake(21, lblTitle.frame.origin.y + lblTitle.bounds.size.height + 10, 250, bodyEntryHeight * bodyEntryCount)];
    bodyView.layer.borderColor = lineColor.CGColor;
    bodyView.layer.borderWidth = 1;
    for(int i=1; i<= bodyEntryCount; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 3.5f + (i - 1) * bodyEntryHeight, 60, 28)];
        titleLabel.textColor = [UIColor appFontGray];
        titleLabel.font = [UIFont systemFontOfSize:16.f];
        titleLabel.backgroundColor = [UIColor clearColor];
        [bodyView addSubview:titleLabel];

        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x + 84, titleLabel.frame.origin.y, 150, 28)];
        detailLabel.textColor = [UIColor darkTextColor];
        detailLabel.font = [UIFont systemFontOfSize:14.f];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textAlignment = NSTextAlignmentRight;
        [bodyView addSubview:detailLabel];

        if(self.registerOrder != nil) {
            if(i == 1) {
                titleLabel.text = NSLocalizedString(@"register_people", @"");
                detailLabel.text = [Account myAccount].name;
            } else if(i == 2) {
                titleLabel.text = NSLocalizedString(@"clinic_card", @"");
                detailLabel.text = [Account myAccount].clinicCard.cardNumber;
            } else if(i == 3) {
                titleLabel.text = NSLocalizedString(@"time", @"");
                detailLabel.text = [self.registerOrder formattedRegisterDateString];
            } else if(i == 4) {
                titleLabel.text = NSLocalizedString(@"hospital", @"");
                detailLabel.text = NSLocalizedString(@"hospital_name", @"");
            } else if(i == 5) {
                titleLabel.text = NSLocalizedString(@"department", @"");
                if(self.registerOrder.department != nil) {
                    detailLabel.text = self.registerOrder.department.name.sourceString;
                }
            } else if(i == 7 || ((i == 6) &&
                    (self.registerOrder.registerType == RegisterTypeOutpatient) )) {
                titleLabel.text = NSLocalizedString(@"register_price", @"");
                detailLabel.textColor = [UIColor redColor];
                float registerPrice;
                if(RegisterTypeOutpatient == self.registerOrder.registerType) {
                    registerPrice = self.registerOrder.department.registerPrice;
                } else {
                    registerPrice = self.registerOrder.expert.registerPrice;
                }
                detailLabel.text = [NSString stringWithFormat:@"￥ %.2f", registerPrice];
            } else {
                titleLabel.text = NSLocalizedString(@"medical", @"");
                if(RegisterTypeExpert == self.registerOrder.registerType
                        && self.registerOrder.expert != nil) {
                    detailLabel.text = self.registerOrder.expert.name.sourceString;
                }
            }
        }

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, bodyEntryHeight * i, bodyView.bounds.size.width, 1)];
        lineView.backgroundColor = lineColor;
        [bodyView addSubview:lineView];
    }
    [paperBackgroundView addSubview:bodyView];

    // Create Button View
    UIButton *btnConfirmAndPayment = [[UIButton alloc] initWithFrame:CGRectMake(21, bodyView.frame.origin.y + bodyView.bounds.size.height + 15, 500 / 2, 80 / 2)];
    [btnConfirmAndPayment addTarget:self action:@selector(submitRegisterOrder:) forControlEvents:UIControlEventTouchUpInside];
    [btnConfirmAndPayment setTitle:NSLocalizedString(@"confirm_and_payment", @"") forState:UIControlStateNormal];
    [btnConfirmAndPayment setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnConfirmAndPayment setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [paperBackgroundView addSubview:btnConfirmAndPayment];
}

- (void)submitRegisterOrder:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    alertView.title = NSLocalizedString(@"register_success", @"");
    alertView.message = @"356号, 前面还有20号";
    [alertView addButtonWithTitle:NSLocalizedString(@"confirm", @"")];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end