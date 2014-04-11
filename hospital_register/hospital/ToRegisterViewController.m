//
// Created by Zhao yang on 3/15/14.
//

#import "ToRegisterViewController.h"
#import "HtmlView.h"
#import "PaperBackgroundView.h"
#import "RegisterViewController.h"

@implementation ToRegisterViewController {
    HtmlView *_htmlView_;
}

- (void)initUI {
    [super initUI];

    self.title = NSLocalizedString(@"i_want_to_register", @"");

    CGFloat contentHeight = [UIScreen mainScreen].bounds.size.height > 480 ? 19 * 19 : 19 * 15;
    PaperBackgroundView *paperBackgroundView = [[PaperBackgroundView alloc] initWithFrame:CGRectMake(14, 0, 0, 19 + contentHeight + 30)];
    [self.view addSubview:paperBackgroundView];
    _htmlView_ = [[HtmlView alloc] initWithFrame:CGRectMake(0, 0, paperBackgroundView.bounds.size.width, paperBackgroundView.bounds.size.height - 30)];
    [paperBackgroundView addSubview:_htmlView_];

    UIButton *btnExpertRegister = [[UIButton alloc] initWithFrame:
            CGRectMake(13, self.view.bounds.size.height - self.standardTopbarHeight - ([UIScreen mainScreen].bounds.size.height <= 480 ? 62 : 70), 288 / 2, 77.f / 2)];
    [btnExpertRegister setTitle:NSLocalizedString(@"expert_register", @"") forState:UIControlStateNormal];
    [btnExpertRegister setBackgroundImage:[UIImage imageNamed:@"btn_yellow_middle"] forState:UIControlStateNormal];
    [btnExpertRegister setBackgroundImage:[UIImage imageNamed:@"btn_yellow_middle_highlighted"] forState:UIControlStateHighlighted];
    [btnExpertRegister addTarget:self action:@selector(btnExpertRegisterPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnExpertRegister];

    UIButton *btnGeneralRegister = [[UIButton alloc] initWithFrame:
            CGRectMake(btnExpertRegister.bounds.size.width + btnExpertRegister.frame.origin.x + 7, btnExpertRegister.frame.origin.y, 288 / 2, 77.f / 2)];
    [btnGeneralRegister setTitle:NSLocalizedString(@"general_register", @"") forState:UIControlStateNormal];
    [btnGeneralRegister setBackgroundImage:[UIImage imageNamed:@"btn_blue_middle"] forState:UIControlStateNormal];
    [btnGeneralRegister setBackgroundImage:[UIImage imageNamed:@"btn_blue_middle_highlighted"] forState:UIControlStateHighlighted];
    [btnGeneralRegister addTarget:self action:@selector(btnGeneralRegisterPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnGeneralRegister];
}

- (void)setUp {
    [super setUp];

    // adding local file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"register_notice" ofType:@"html"];
    NSString *htmlString = [[NSString alloc] initWithData:[[NSData alloc] initWithContentsOfFile:filePath] encoding:NSUTF8StringEncoding];
    [_htmlView_ loadWithHtmlString:htmlString];
}

- (void)btnGeneralRegisterPressed:(id)sender {
    OutpatientDepartmentPickerViewController *picker = [[OutpatientDepartmentPickerViewController alloc] initWithDepartmentType:DepartmentTypeNormalOutpatient];
    picker.delegate = self;
    picker.title = NSLocalizedString(@"outpatient_deparment_list", @"");
    [self.navigationController pushViewController:picker animated:YES];
}

- (void)btnExpertRegisterPressed:(id)sender {
    OutpatientDepartmentPickerViewController *picker = [[OutpatientDepartmentPickerViewController alloc] initWithDepartmentType:DepartmentTypeExpertOutpatient];
    picker.title = NSLocalizedString(@"outpatient_department_expert", @"");
    picker.delegate = self;
    [self.navigationController pushViewController:picker animated:YES];
}

#pragma mark -
#pragma mark Outpatient Department Picker Delegate

- (void)outpatientDepartmentPicker:(OutpatientDepartmentPickerViewController *)outpatientDepartmentPicker didSelectDepartment:(Department *)department {
    if(DepartmentTypeNormalOutpatient == outpatientDepartmentPicker.departmentType) {
        RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithDepartment:department];
        [self.navigationController pushViewController:registerViewController animated:YES];
    } else if(DepartmentTypeExpertOutpatient == outpatientDepartmentPicker.departmentType) {
        OutpatientDepartmentExpertPickerViewController *viewController =
                [[OutpatientDepartmentExpertPickerViewController alloc] initWithDepartment:department];
        viewController.delegate = self;
        viewController.title = department.name.sourceString;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark -
#pragma mark Outpatient Department Expert Picker Delegate

- (void)outpatientDepartmentExpertPicker:
        (OutpatientDepartmentExpertPickerViewController *)outpatientDepartmentExpertPicker
        didSelectExpert:(Expert *)expert registerDate:(NSDate *)date {
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithExpert:expert registerDate:date];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

@end