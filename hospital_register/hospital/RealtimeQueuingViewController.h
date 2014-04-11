//
// Created by Zhao yang on 3/25/14.
//

#import <Foundation/Foundation.h>
#import "ToPortalNavigationViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "Expert.h"

@interface RealtimeQueuingViewController :
        ToPortalNavigationViewController<UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;

    //  Reloading var should really be your tableviews datasource
    //  Putting it here for demo purposes
    BOOL _reloading;
}


@property (nonatomic, strong) Department* department;
@property (nonatomic, strong) Expert* expert;

- (instancetype)initWithDepartment:(Department *)department;
- (instancetype)initWithExpert:(Expert *)expert;

@end