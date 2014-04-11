//
// Created by Zhao yang on 3/20/14.
//

#import "RegisterViewController.h"
#import "PaperBackgroundView.h"
#import "RegisterConfirmViewController.h"
#import "Department.h"
#import "HtmlView.h"
#import "ChineseWeekdayUtils.h"

@implementation RegisterViewController {
    HtmlView *_htmlView_;
    UITableView *tblRegisterDetails;
    RegisterOrder *registerOrder;
}

@synthesize expert = _expert_;
@synthesize department = _department_;

- (instancetype)initWithExpert:(Expert *)expert registerDate:(NSDate *)registerDate {
    self = [super init];
    if(self) {
        self.expert = expert;
        registerOrder = [[RegisterOrder alloc] init];
        registerOrder.registerType = RegisterTypeExpert;
        registerOrder.expert = self.expert;
        registerOrder.registerDate = registerDate;

        NSInteger weekDay = [ChineseWeekdayUtils chineseWeekDayForDate:registerDate];
        BOOL idleAM = [self.expert isIdleForExpertIdleDate:1 << (weekDay - 1) expertIdleTime:ExpertIdleTimeMorning];

        // Set default date and time
        registerOrder.expertIdleTime = idleAM ? ExpertIdleTimeMorning : ExpertIdleTimeAfternoon;
    }
    return self;
}

- (instancetype)initWithDepartment:(Department *)department {
    self = [super init];
    if(self) {
        self.department = department;
        registerOrder = [[RegisterOrder alloc] init];
        registerOrder.registerType = RegisterTypeOutpatient;
        registerOrder.department = self.department;
        registerOrder.expertIdleTime = ExpertIdleTimeMorning;

        // Set default date
        registerOrder.registerDate = [NSDate date];
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];

    CGFloat contentHeight = 0;
    if(registerOrder.registerType == RegisterTypeOutpatient) {
        self.title = self.department.name.sourceString;
        contentHeight = [UIScreen mainScreen].bounds.size.height > 480 ? 19 * 19 : 19 * 14;
    } else {
        self.title = self.expert.name.sourceString;
        contentHeight = [UIScreen mainScreen].bounds.size.height > 480 ? 19 * 15 : 19 * 11;
    }

    PaperBackgroundView *paperBackgroundView = [[PaperBackgroundView alloc] initWithFrame:CGRectMake(14, 0, 0, contentHeight)];
    [self.view addSubview:paperBackgroundView];

    _htmlView_ = [[HtmlView alloc] initWithFrame:CGRectMake(0, 0, paperBackgroundView.bounds.size.width, paperBackgroundView.bounds.size.height - 30)];
    [paperBackgroundView addSubview:_htmlView_];

    UIButton *btnRegister = [[UIButton alloc] initWithFrame:
            CGRectMake(15, self.view.bounds.size.height - self.standardTopbarHeight - 90 / 2 - 10, 580 / 2, 90 / 2)];
    [btnRegister setTitle:NSLocalizedString(@"to_register", @"") forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [btnRegister addTarget:self action:@selector(btnRegisterPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRegister];

    NSInteger cellCount = registerOrder.registerType == RegisterTypeOutpatient ? 1 : 3;
    tblRegisterDetails = [[UITableView alloc] initWithFrame:
            CGRectMake(0, btnRegister.frame.origin.y - 44 * cellCount - (cellCount == 1 ? 25 : 10), self.view.bounds.size.width, 44 * cellCount) style:UITableViewStylePlain];
    tblRegisterDetails.backgroundColor = [UIColor clearColor];
    tblRegisterDetails.delegate = self;
    tblRegisterDetails.dataSource = self;
    tblRegisterDetails.scrollEnabled = NO;

    [self.view addSubview:tblRegisterDetails];
}

- (void)setUp {
    [super setUp];
    NSString *fileName = registerOrder.registerType == RegisterTypeOutpatient ? @"department_introduce" : @"expert_introduce";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    NSString *htmlString = [[NSString alloc] initWithData:[[NSData alloc] initWithContentsOfFile:filePath] encoding:NSUTF8StringEncoding];
    [_htmlView_ loadWithHtmlString:htmlString];
}

- (void)btnRegisterPressed:(id)sender {
    RegisterConfirmViewController *registerConfirmViewController = [[RegisterConfirmViewController alloc] initWithRegisterOrder:registerOrder];
    [self.navigationController pushViewController:registerConfirmViewController animated:YES];
}

#pragma mark -
#pragma mark Register Date Picker View Delegate

- (void)registerDatePickerView:(RegisterDatePickerView *)registerDatePickerView didSelectDate:(NSDate *)date expertIdleTime:(ExpertIdleTime)expertIdleTime {
    registerOrder.registerDate = date;
    registerOrder.expertIdleTime = expertIdleTime;
    [tblRegisterDetails reloadData];
}

#pragma mark -
#pragma mark Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return registerOrder.registerType == RegisterTypeOutpatient? 1 : 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor appBackgroundWhite];
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor appBackgroundYellow];
        cell.backgroundView.backgroundColor = [UIColor appBackgroundWhite];
        cell.textLabel.textColor = [UIColor appFontGray];
        cell.textLabel.highlightedTextColor = [UIColor appFontGray];
        cell.textLabel.font = [UIFont systemFontOfSize:16.f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
    }

    if(indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.detailTextLabel.textColor = [UIColor appFontGray];
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.textColor = [UIColor colorWithRed:58.f / 255.f green:125.f / 255.f blue:217.f / 255.f alpha:1.0f];
    }
    
    cell.detailTextLabel.highlightedTextColor = cell.detailTextLabel.textColor;

    if(indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"register_time", @"");
        cell.detailTextLabel.text = registerOrder.formattedRegisterDateStringWithWeekDay;
    } else if(indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"register_number_remain", @"");
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)self.expert.registerNumbersRemain];
    } else {
        cell.textLabel.text = NSLocalizedString(@"register_cost", @"");
        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f", self.expert.registerPrice];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        RegisterDatePickerView *pickerView = nil;
        if(RegisterTypeExpert == registerOrder.registerType) {
            pickerView = [[RegisterDatePickerView alloc] initWithFrame:
                          CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 0, 0)
                          expert:self.expert expertIdleDate:1 << ([ChineseWeekdayUtils chineseWeekDayForDate:registerOrder.registerDate] - 1)
                          expertIdleTime:registerOrder.expertIdleTime];
        } else {
            pickerView = [[RegisterDatePickerView alloc]
                    initWithFrame:CGRectMake(0,
                            [UIScreen mainScreen].bounds.size.height, 0, 0)
                            date:registerOrder.registerDate idleTime:registerOrder.expertIdleTime];
        }
        pickerView.delegate = self;
        [pickerView showInView:self.navigationController.view];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end