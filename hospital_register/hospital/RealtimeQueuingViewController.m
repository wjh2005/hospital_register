//
// Created by Zhao yang on 3/25/14.
//

#import "RealtimeQueuingViewController.h"
#import "Department.h"
#import "RegisterNumber.h"

typedef NS_ENUM(NSInteger , DisplayMode) {
    DisplayModeNormal,
    DisplayModeEmptyView,
};

@implementation RealtimeQueuingViewController {
    UITableView *tblRegisterNumbers;
    NSMutableArray *registerNumbers;

    NSDateFormatter *dateFormatter;
    DisplayMode displayMode;
}

@synthesize department = _department_;
@synthesize expert = _expert_;

- (instancetype)initWithDepartment:(Department *)department {
    self = [super init];
    if(self) {
        self.department = department;
    }
    return self;
}

- (instancetype)initWithExpert:(Expert *)expert {
    self = [super init];
    if(self) {
        self.expert = expert;
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
    registerNumbers = [NSMutableArray array];
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm:ss";
}

- (void)initUI {
    [super initUI];

    self.title = NSLocalizedString(@"real_time_queuing", @"");

    tblRegisterNumbers = [[UITableView alloc] initWithFrame:
            CGRectMake(14, 0, 292, self.view.bounds.size.height - self.standardTopbarHeight) style:UITableViewStylePlain];
    tblRegisterNumbers.dataSource = self;
    tblRegisterNumbers.delegate = self;
    tblRegisterNumbers.showsVerticalScrollIndicator = NO;
    tblRegisterNumbers.backgroundColor = [UIColor clearColor];
    tblRegisterNumbers.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tblRegisterNumbers];

    _refreshHeaderView = [[EGORefreshTableHeaderView alloc]
            initWithFrame:CGRectMake(0.0f, 0.0f - tblRegisterNumbers.bounds.size.height,
                    tblRegisterNumbers.frame.size.width, tblRegisterNumbers.bounds.size.height)
            arrowImageName:@"grayArrow" textColor:[UIColor appFontGray]];

    _refreshHeaderView.backgroundColor = [UIColor appBackgroundGray];
    _refreshHeaderView.delegate = self;
    [tblRegisterNumbers addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)setUp {
    [super setUp];
    [self refresh];
}

- (void)refresh {
    [registerNumbers removeAllObjects];
    [self mockRegisterNumbers];

    if(registerNumbers == nil || registerNumbers.count == 0) {
        displayMode = DisplayModeEmptyView;
    } else {
        displayMode = DisplayModeNormal;
    }
    [tblRegisterNumbers reloadData];
}

/*
 * Mock some register numbers for Demo
 *
 */
- (void)mockRegisterNumbers {
    NSDate *now = [NSDate date];

    NSInteger numbersCount = arc4random() % 17;
    for(int i=0; i<numbersCount; i++) {
        RegisterNumber *rn = [[RegisterNumber alloc] initWithNumber:(90 + arc4random() % 100)
                             updateDate:[now dateByAddingTimeInterval:(0 - (arc4random() % (2 * 60 * 60)))]];
        [registerNumbers addObject:rn];
    }
}

#pragma mark -
#pragma mark Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isLastOne = [self isLastRowForIndexPath:indexPath];
    BOOL isFirstOne = [self isFirstRowForIndexPath:indexPath];
    if(isLastOne) {
        return 25;
    } else if(isFirstOne) {
        return 19 * 3;
    }
    return 19 * 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(DisplayModeEmptyView == displayMode) return 3;
    if(registerNumbers == nil || registerNumbers.count == 0) return 0;
    return registerNumbers.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    static NSString *cellTopIdentifier = @"cellTopIdentifier";
    static NSString *cellBottomIdentifier = @"cellBottomIdentifier";
    
    static NSString *cellEmptyIdentifier = @"cellEmptyIdentifier";

    NSString *_cellIdentifier;
    BOOL isFirstOne = [self isFirstRowForIndexPath:indexPath];
    BOOL isLastOne = [self isLastRowForIndexPath:indexPath];
    
    if(DisplayModeEmptyView == displayMode) {
        _cellIdentifier = cellEmptyIdentifier;
    } else {
        if(isFirstOne) {
            _cellIdentifier = cellTopIdentifier;
        } else if(isLastOne) {
            _cellIdentifier = cellBottomIdentifier;
        } else {
            _cellIdentifier = cellIdentifier;
        }
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_single"]];

        if(isLastOne) {
            UIImageView *imgBottomBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 292, 25)];
            imgBottomBackground.image = [UIImage imageNamed:@"paper_bottom"];
            [cell addSubview:imgBottomBackground];
        } else if(isFirstOne) {
            // one paper top, three paper_single, and paper top ovrried one of three paper_single
            // finally displayed height is 19(paper_top) + 19(paper_single) * 2

            UIImageView *imgTopBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 292, 19)];
            imgTopBackground.image = [UIImage imageNamed:@"paper_top"];
            [cell addSubview:imgTopBackground];

            UIView *lightBlueBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(2, 19, 288, 19 * 2)];
            lightBlueBackgroundView.backgroundColor = [UIColor colorWithRed:202.f / 255.f green:217.f / 255.f blue:221.f / 255.f alpha:.4f];
            [cell addSubview:lightBlueBackgroundView];

            UILabel *lblNumbersRegistered = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 80, 30)];
            lblNumbersRegistered.text = NSLocalizedString(@"numbers_registered", @"");
            lblNumbersRegistered.backgroundColor = [UIColor clearColor];
            lblNumbersRegistered.font = [UIFont systemFontOfSize:13.f];
            lblNumbersRegistered.textColor = [UIColor appFontGray];
            [lightBlueBackgroundView addSubview:lblNumbersRegistered];

            UILabel *lblDepartmentName = [[UILabel alloc] initWithFrame:
                    CGRectMake(lightBlueBackgroundView.bounds.size.width - 180 - 20, 4, 180, 30)];
            lblDepartmentName.text = NSLocalizedString(@"numbers_registered", @"");
            lblDepartmentName.textAlignment = NSTextAlignmentRight;
            lblDepartmentName.backgroundColor = [UIColor clearColor];
            lblDepartmentName.font = [UIFont systemFontOfSize:13.f];
            lblDepartmentName.textColor = [UIColor appFontGray];

            lblDepartmentName.text = self.department.name.sourceString;
            [lightBlueBackgroundView addSubview:lblDepartmentName];
        } else {
            UIColor *lineColor = [UIColor colorWithRed:172.f / 255.f green:170.f / 255.f blue:150.f / 255.f alpha:1];
            UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 250, 44)];
            borderView.tag = 100;
            borderView.center = CGPointMake(292 / 2, (19.f * 3) / 2);
            borderView.layer.borderWidth = 1;
            borderView.layer.borderColor = lineColor.CGColor;
            [cell addSubview:borderView];

            if(DisplayModeNormal == displayMode) {
                UIView *hSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(60, 0, 1, borderView.bounds.size.height)];
                hSeparatorLine.backgroundColor = lineColor;
                [borderView addSubview:hSeparatorLine];

                UILabel *lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, borderView.bounds.size.height)];
                lblNumber.tag = 101;
                lblNumber.textAlignment = NSTextAlignmentCenter;
                lblNumber.backgroundColor = [UIColor clearColor];
                lblNumber.font = [UIFont systemFontOfSize:25.f];
                lblNumber.textColor = [UIColor appFontGray];
                [borderView addSubview:lblNumber];

                UILabel *lblUpdateTime = [[UILabel alloc] initWithFrame:CGRectMake(borderView.bounds.size.width - 155, 22, 150, 22)];
                lblUpdateTime.tag = 102;
                lblUpdateTime.backgroundColor = [UIColor clearColor];
                lblUpdateTime.textColor = [UIColor appFontGray];
                lblUpdateTime.font = [UIFont systemFontOfSize:12.f];
                lblUpdateTime.textAlignment = NSTextAlignmentRight;
                [borderView addSubview:lblUpdateTime];

                // for expert register

                if(self.expert != nil) {
                    UIView *vSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(
                            hSeparatorLine.frame.origin.x, borderView.bounds.size.height / 2.f,
                            borderView.bounds.size.width - hSeparatorLine.frame.origin.x, 1)];
                    vSeparatorLine.backgroundColor = lineColor;
                    [borderView addSubview:vSeparatorLine];

                    UILabel *lblMedicalName = [[UILabel alloc] initWithFrame:CGRectMake(borderView.bounds.size.width - 47, 0, 40, 22)];
                    lblMedicalName.backgroundColor = [UIColor clearColor];
                    lblMedicalName.textColor = [UIColor darkTextColor];
                    lblMedicalName.font = [UIFont systemFontOfSize:12.f];
                    lblMedicalName.textAlignment = NSTextAlignmentCenter;
                    lblMedicalName.text = self.expert.name.sourceString;
                    [borderView addSubview:lblMedicalName];

                    UIImageView *imgMedical = [[UIImageView alloc] initWithFrame:
                            CGRectMake(lblMedicalName.frame.origin.x - 18, 3.5f, 30.f / 2, 32.f / 2)];
                    imgMedical.image = [UIImage imageNamed:@"img_medical"];
                    [borderView addSubview:imgMedical];
                }
            } else {
                UILabel *lblEmptyTips = [[UILabel alloc] initWithFrame:CGRectMake((borderView.bounds.size.width - 180) / 2, 4, 180, 34)];
                lblEmptyTips.textAlignment = NSTextAlignmentCenter;
                lblEmptyTips.text = NSLocalizedString(@"queuing_not_start", @"");
                lblEmptyTips.backgroundColor = [UIColor clearColor];
                lblEmptyTips.font = [UIFont systemFontOfSize:20.f];
                lblEmptyTips.textColor = [UIColor appFontGray];
                [borderView addSubview:lblEmptyTips];
            }
        }
    }

    NSInteger index = indexPath.row - 1;
    if(!isFirstOne && !isLastOne && (DisplayModeNormal == displayMode)) {
        RegisterNumber *registerNumber = [registerNumbers objectAtIndex:index];
        UIView *borderView = [cell viewWithTag:100];
        if(borderView != nil) {
            UILabel *lblNumber = (UILabel *)[borderView viewWithTag:101];
            UILabel *lblUpdateTime = (UILabel *)[borderView viewWithTag:102];
            lblNumber.text = [NSString stringWithFormat:@"%ld", (long)registerNumber.number];
            lblUpdateTime.text = [NSString
                    stringWithFormat:@"%@ %@", NSLocalizedString(@"update_on", @""),
                    registerNumber.updateDate == nil ? @"" : [dateFormatter stringFromDate:registerNumber.updateDate]];
        }
    }

    return cell;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
    _reloading = YES;
    [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(delayRefresh) userInfo:nil repeats:NO];
}

- (void)delayRefresh {
    [self refresh];
}

- (void)doneLoadingTableViewData {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tblRegisterNumbers];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.f];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
    return [NSDate date];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark UI Methods

- (BOOL)isLastRowForIndexPath:(NSIndexPath *)indexPath {
    if(DisplayModeEmptyView == displayMode) {
        return indexPath.row == 2;
    }

    if(registerNumbers == nil && indexPath.row == 1) return YES;
    return indexPath.row == registerNumbers.count + 1;
}

- (BOOL)isFirstRowForIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0;
}

- (Department *)department {
    if(self.expert != nil) {
        return self.expert.department;
    } else {
        return _department_;
    }
}

@end