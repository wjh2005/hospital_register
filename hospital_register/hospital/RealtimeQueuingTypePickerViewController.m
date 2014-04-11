//
// Created by Zhao yang on 3/17/14.
//

#import "RealtimeQueuingTypePickerViewController.h"
#import "RealtimeQueuingViewController.h"

@implementation RealtimeQueuingTypePickerViewController {

}

- (void)initUI {
    [super initUI];

    // set dateTitle
    self.title = NSLocalizedString(@"real_time_queuing", @"");

    // create general queuing button
    UIButton *btnGeneralQueuing = [[UIButton alloc] initWithFrame:
            CGRectMake(15, 20, 580 / 2, 90 / 2)];
    btnGeneralQueuing.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0 );
    btnGeneralQueuing.titleLabel.font = [UIFont systemFontOfSize:20.f];
    [btnGeneralQueuing setTitle:NSLocalizedString(@"outpatient_queuing", @"") forState:UIControlStateNormal];
    [btnGeneralQueuing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnGeneralQueuing setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnGeneralQueuing setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [btnGeneralQueuing addTarget:self action:@selector(btnGeneralQueuingPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnGeneralQueuing];

    // create expert queuing button
    UIButton *btnExpertQueuing = [[UIButton alloc] initWithFrame:
            CGRectMake(15, btnGeneralQueuing.frame.origin.y + btnGeneralQueuing.bounds.size.height + 20, 580 / 2, 90 / 2)];
    btnExpertQueuing.titleEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
    btnExpertQueuing.titleLabel.font = [UIFont systemFontOfSize:20.f];
    [btnExpertQueuing setTitle:NSLocalizedString(@"expert_queuing", @"") forState:UIControlStateNormal];
    [btnExpertQueuing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnExpertQueuing setBackgroundImage:[UIImage imageNamed:@"btn_yellow"] forState:UIControlStateNormal];
    [btnExpertQueuing setBackgroundImage:[UIImage imageNamed:@"btn_yellow_highlighted"] forState:UIControlStateHighlighted];
    [btnExpertQueuing addTarget:self action:@selector(btnExpertQueuingPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnExpertQueuing];
}

- (void)btnGeneralQueuingPressed:(id)sender {
    OutpatientDepartmentPickerViewController *departmentPicker =
            [[OutpatientDepartmentPickerViewController alloc] initWithDepartmentType:DepartmentTypeNormalOutpatient];
    departmentPicker.delegate = self;
    departmentPicker.title = NSLocalizedString(@"outpatient_deparment_list", @"");
    [self.navigationController pushViewController:departmentPicker animated:YES];
}

- (void)btnExpertQueuingPressed:(id)sender {
    ExpertPickerViewController *expertPicker = [[ExpertPickerViewController alloc] init];
    expertPicker.delegate = self;
    expertPicker.title = NSLocalizedString(@"experts_today", @"");
    [self.navigationController pushViewController:expertPicker animated:YES];
}

#pragma mark -
#pragma mark Outpatient Department Picker Delegate

- (void)outpatientDepartmentPicker:(OutpatientDepartmentPickerViewController *)outpatientDepartmentPicker didSelectDepartment:(Department *)department {
    RealtimeQueuingViewController *viewController = [[RealtimeQueuingViewController alloc] initWithDepartment:department];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -
#pragma mark Expert Picker Delegate

- (void)expertPicker:(ExpertPickerViewController *)expertPickerViewController didSelectExpert:(Expert *)expert {
    RealtimeQueuingViewController *viewController = [[RealtimeQueuingViewController alloc] initWithExpert:expert];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end