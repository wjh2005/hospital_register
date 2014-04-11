//
// Created by Zhao yang on 3/17/14.
//

#import "OutpatientDepartmentExpertPickerViewController.h"
#import "ChineseWeekdayUtils.h"
#import "ExpertCell.h"
#import "CellStyleButton.h"

@implementation OutpatientDepartmentExpertPickerViewController {
    CellStyleButton *btnFilter;

    UITableView *tblOutpatientDepartmentExperts;

    NSMutableArray *expertGroups;
    NSMutableArray *filteredExpertGroups;

    /*
     * -1 is within a week
     * others references enumeration 'ExpertIdleDate'
     * default weekDayValue is -1
     */
    NSInteger idleDateFilter;

    // reuse date format
    NSDateFormatter *dateFormatter;
}

@synthesize department = _department_;
@synthesize delegate;

- (id)initWithDepartment:(Department *)department {
    self = [super init];
    if(self) {
        self.department = department;
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];

    idleDateFilter = -1;

    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
}
- (void)initUI {
    [super initUI];

    btnFilter = [CellStyleButton buttonWithPoint:CGPointMake(0, 0)];
    btnFilter.textLabel.text = NSLocalizedString(@"outpatient_department_time", @"");
    btnFilter.detailTextLabel.text = NSLocalizedString(@"within_a_week", @"");
    [btnFilter addTarget:self action:@selector(showDatePickerView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFilter];

    tblOutpatientDepartmentExperts = [[UITableView alloc] initWithFrame:
            CGRectMake(0, btnFilter.bounds.size.height, self.view.bounds.size.width,
            self.view.bounds.size.height - self.standardTopbarHeight - btnFilter.bounds.size.height) style:UITableViewStylePlain];
    tblOutpatientDepartmentExperts.delegate = self;
    tblOutpatientDepartmentExperts.dataSource = self;
    [self.view addSubview:tblOutpatientDepartmentExperts];
}

- (void)viewWillAppear:(BOOL)animated {
    [self refresh];
}

- (void)refresh {
    if(expertGroups == nil) {
        expertGroups = [NSMutableArray array];
    } else {
        [expertGroups removeAllObjects];
    }

    if(filteredExpertGroups == nil) {
        filteredExpertGroups = [NSMutableArray array];
    }

    NSDate *today = [NSDate date];

    // convert to chinese week day
    NSInteger weekdayToday = [ChineseWeekdayUtils chineseWeekDayToday];

    for(int i=0; i<7; i++) {
        NSInteger day = (i + weekdayToday) > 7 ? (i + weekdayToday - 7) : (i + weekdayToday);

        NSArray *weekdayExperts = [self.department idleExpertsForExpertIdleDate:1 << (day - 1)];
        if(i == 0 || weekdayExperts.count > 0) {
            ExpertsWrapper *ew = [[ExpertsWrapper alloc] init];

            // set week day
            ew.weekDay = day;
            ew.isToday = day == weekdayToday;

            // set date
            if(i == 0) {
                // today
                ew.date = today;

                // set except date well format string
                ew.dateWellFormatString = NSLocalizedString(@"today", @"");
            } else {
                // next day
                ew.date = [today initWithTimeIntervalSinceNow:24 * 60 * 60 * i];
            }

            // set date well format string
            if([XXStringUtils isBlank:ew.dateWellFormatString]) {
                ew.dateWellFormatString = [NSString stringWithFormat:@"%@ (%@)",
                            [ChineseWeekdayUtils chineseWeekDayWithWeekdayNumber:day], [dateFormatter stringFromDate:ew.date]];
            }

            // set experts
            ew.experts = weekdayExperts;

            [expertGroups addObject:ew];
        }
    }

    [self filterExpertGroupsWithIdleDataFilter];
}

- (void)filterExpertGroupsWithIdleDataFilter {
    [filteredExpertGroups removeAllObjects];
    if(idleDateFilter == -1) {
        [filteredExpertGroups addObjectsFromArray:expertGroups];
    } else {
        for(ExpertsWrapper *ew in expertGroups) {
            if((1 << ew.weekDay) == idleDateFilter) {
                [filteredExpertGroups addObject:ew];
                break;
            }
        }
    }
    [tblOutpatientDepartmentExperts reloadData];
}

#pragma mark -
#pragma mark UI Events

- (void)showDatePickerView:(id)sender {
    ExpertIdleDatePickerView *datePickerView =
            [[ExpertIdleDatePickerView alloc]
                    initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 0, 0)
                    expertsWrappers:expertGroups];
    datePickerView.defaultIdleDate = idleDateFilter;
    datePickerView.delegate = self;
    [datePickerView showInView:self.navigationController.view];
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(filteredExpertGroups == nil) return 0;
    return filteredExpertGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(filteredExpertGroups == nil || filteredExpertGroups.count == 0) return 0;
    if(section >= filteredExpertGroups.count) return 0;

    ExpertsWrapper *ew = [filteredExpertGroups objectAtIndex:section];
    if(ew.experts == nil) return 0;
    if(ew.experts.count > 0) return ew.experts.count;

    // if experts count is zero
    return ew.isToday ? 1 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kExpertCellHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ExpertsWrapper *ew = [filteredExpertGroups objectAtIndex:section];
    return ew.dateWellFormatString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(filteredExpertGroups == nil) return 0;
    return filteredExpertGroups.count - 1 == section ? 1 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tblOutpatientDepartmentExperts.bounds.size.width, 24)];
    view.backgroundColor = [UIColor appLightBlue];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 220, 20)];
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor appFontGray];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:titleLabel];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    static NSString *emptyCellIdentifier = @"emptyCellIdentifier";

    BOOL hasValue = YES;
    ExpertsWrapper *ew = [filteredExpertGroups objectAtIndex:indexPath.section];
    if(ew.experts == nil || ew.experts.count == 0) {
        hasValue = NO;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hasValue ? cellIdentifier : emptyCellIdentifier];
    if(cell == nil) {
       if(hasValue) {
            cell = [[ExpertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier expertCellType:ExpertCellTypeIdleTime];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyCellIdentifier];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 16, 280, 56)];
            borderView.center = CGPointMake(cell.center.x, borderView.center.y);
            borderView.layer.cornerRadius = 12;
            borderView.layer.borderWidth = 1;
            borderView.layer.borderColor = [UIColor lightGrayColor].CGColor;

            UILabel *lblEmptyTips = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 240, 36)];
            lblEmptyTips.backgroundColor = [UIColor clearColor];
            lblEmptyTips.text = NSLocalizedString(@"no_experts_today", @"");
            lblEmptyTips.textColor = [UIColor blackColor];
            lblEmptyTips.textAlignment = NSTextAlignmentCenter;
            lblEmptyTips.font = [UIFont systemFontOfSize:22.f];
            [borderView addSubview:lblEmptyTips];

            [cell.contentView addSubview:borderView];
       }
    }

    if(hasValue) {
        [((ExpertCell *) cell) setExpert:[ew.experts objectAtIndex:indexPath.row] withIdleDate:1 << (ew.weekDay - 1)];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section >= filteredExpertGroups.count) return;
    ExpertsWrapper *ew = [filteredExpertGroups objectAtIndex:indexPath.section];

    if(indexPath.row >= ew.experts.count) return;
    Expert *expert = [ew.experts objectAtIndex:indexPath.row];

    if(self.delegate != nil
            && [self.delegate respondsToSelector:@selector(outpatientDepartmentExpertPicker:didSelectExpert:registerDate:)]) {
        [self.delegate outpatientDepartmentExpertPicker:self didSelectExpert:expert registerDate:ew.date];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark ExpertIdle Date Picker View Delegate

- (void)expertIdleDatePickerView:(ExpertIdleDatePickerView *)expertIdleDatePickerView didSelectValue:(NSInteger)value title:(NSString *)title {
    btnFilter.detailTextLabel.text = title;
    idleDateFilter = value;
    [self filterExpertGroupsWithIdleDataFilter];
}

#pragma mark -
#pragma mark Getter and Setters

- (void)setDepartment:(Department *)department {
    _department_ = department;
}

@end