//
// Created by Zhao yang on 3/18/14.
//

#import "ReportsViewController.h"
#import "WebViewController.h"

@implementation ReportsViewController {
    UITableView *tblReports;
    NSMutableArray *reports;

    NSDateFormatter *dateFormatter;
}

@synthesize reportType = _reportType_;

- (instancetype)initWithReportType:(ReportType)reportType {
    self = [super init];
    if(self) {
        self.reportType = reportType;
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];

    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";

    reports = [NSMutableArray array];
}

- (void)initUI {
    [super initUI];

    if(ReportTypeReport == self.reportType) {
       self.title = NSLocalizedString(@"report_queries", @"");
    } else {
       self.title = NSLocalizedString(@"medical_order_query", @"");
    }

    tblReports = [[UITableView alloc]
            initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.standardTopbarHeight) style:UITableViewStylePlain];
    tblReports.dataSource = self;
    tblReports.delegate = self;
    tblReports.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tblReports];

    _refreshHeaderView = [[EGORefreshTableHeaderView alloc]
            initWithFrame:CGRectMake(0.0f, 0.0f - tblReports.bounds.size.height,
                    tblReports.frame.size.width, tblReports.bounds.size.height)
           arrowImageName:@"grayArrow" textColor:[UIColor appFontGray]];

    _refreshHeaderView.backgroundColor = [UIColor appBackgroundGray];
    _refreshHeaderView.delegate = self;
    [tblReports addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)setUp {
    [super setUp];

    [self refresh];
}

- (void)refresh {
    [reports removeAllObjects];

    /* Generate Mock Reports */

    Report *report1 = [[Report alloc] init];
    report1.name = @"球后全部血管彩色多普勒超声";
    report1.identifier = @"149225389";
    report1.date = [dateFormatter dateFromString:@"2013-03-27"];
    report1.hasRead = NO;

    Report *report2 = [[Report alloc] init];
    report2.name = @"人工制定治疗计划(复杂)";
    report2.identifier = @"168706638";
    report2.date = [dateFormatter dateFromString:@"2013-02-19"];
    report2.hasRead = YES;

    Report *report3 = [[Report alloc] init];
    report3.name = @"抗血小板膜糖蛋白自身抗体测定";
    report3.identifier = @"157076670";
    report3.date = [dateFormatter dateFromString:@"2013-02-09"];
    report3.hasRead = YES;

    [reports addObject:report1];
    [reports addObject:report2];
    [reports addObject:report3];

    [tblReports reloadData];
}

#pragma mark -
#pragma mark Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return reports == nil ? 0 : reports.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor appBackgroundYellow];

        UILabel *lblReportName = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 220, 34)];
        lblReportName.font = [UIFont systemFontOfSize:15.f];
        lblReportName.textColor = [UIColor appFontDarkGray];
        lblReportName.numberOfLines = 2;
        lblReportName.tag = 666;
        lblReportName.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lblReportName];

//        UILabel *lblIdentifierTips = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 60, 23)];
        UILabel *lblDateTips = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 60, 23)];
        lblDateTips.font = [UIFont systemFontOfSize:12.f];
        lblDateTips.textColor = [UIColor appFontGray];
//        lblIdentifierTips.font = [UIFont systemFontOfSize:12.f];
//        lblIdentifierTips.textColor = [UIColor appFontGray];
//        lblIdentifierTips.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"report_id", @"")];
        lblDateTips.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"report_date", @"")];
//        lblIdentifierTips.backgroundColor = [UIColor clearColor];
        lblDateTips.backgroundColor = [UIColor clearColor];
//        [cell.contentView addSubview:lblIdentifierTips];
        [cell.contentView addSubview:lblDateTips];

//        UILabel *lblIdentifier = [[UILabel alloc] initWithFrame:CGRectMake(lblIdentifierTips.frame.origin.x + 65, 42, 150, 23)];
//        lblIdentifier.backgroundColor = [UIColor clearColor];
//        lblIdentifier.tag = 888;
//        lblIdentifier.textColor = [UIColor appFontGray];
//        lblIdentifier.font = [UIFont systemFontOfSize:12.f];

        UILabel *lblDate = [[UILabel alloc] initWithFrame:CGRectMake(lblDateTips.frame.origin.x + 50, 42, 150, 23)];
        lblDate.backgroundColor = [UIColor clearColor];
        lblDate.tag = 999;
        lblDate.textColor = [UIColor appFontGray];
        lblDate.font = [UIFont systemFontOfSize:12.f];

//        [cell.contentView addSubview:lblIdentifier];
        [cell.contentView addSubview:lblDate];

        UILabel *lblNew = [[UILabel alloc] initWithFrame:CGRectMake(180, 50, 28, 14)];
        lblNew.center = CGPointMake(lblNew.center.x, lblDate.center.y);
        lblNew.tag = 222;
        lblNew.backgroundColor = [UIColor clearColor];
        lblNew.layer.borderWidth = 0.8f;
        lblNew.layer.borderColor = [UIColor orangeColor].CGColor;
        lblNew.text = @"New";
        lblNew.font = [UIFont systemFontOfSize:9.f];
        lblNew.textColor = [UIColor orangeColor];
        lblNew.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:lblNew];
    }

    Report *report = [reports objectAtIndex:indexPath.row];

    UILabel *lblReportName = (UILabel *)[cell.contentView viewWithTag:666];
    lblReportName.text = report.name;

    UILabel *lblIdentifier = (UILabel *)[cell.contentView viewWithTag:888];
    lblIdentifier.text = report.identifier;

    UILabel *lblDate = (UILabel *)[cell.contentView viewWithTag:999];
    lblDate.text = [dateFormatter stringFromDate:report.date];

    UILabel *lblNew = (UILabel *)[cell.contentView viewWithTag:222];
    lblNew.hidden = report.hasRead;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WebViewController *webViewController = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController showEmptyContentViewWithMessage:NSLocalizedString(@"no_data", @"")];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tblReports];
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

@end