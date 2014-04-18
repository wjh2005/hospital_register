//
// Created by Zhao yang on 3/18/14.
//

#import <Foundation/Foundation.h>
#import "NavigationViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "Report.h"

typedef NS_ENUM(NSInteger , ReportType) {
    ReportTypeReport,
    ReportTypeSeeDoctorHistory
};

@interface ReportsViewController :
        NavigationViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;

    //  Reloading var should really be your tableviews datasource
    //  Putting it here for demo purposes
    BOOL _reloading;
}

@property (nonatomic) ReportType reportType;

- (instancetype)initWithReportType:(ReportType)reportType;

@end