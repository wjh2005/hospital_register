//
// Created by Zhao yang on 3/17/14.
//

#import "ExpertPickerViewController.h"
#import "DepartmentsManager.h"
#import "UIColor+Image.h"
#import "ExpertCell.h"
#import "ChineseWeekdayUtils.h"

@interface DepartmentExpertsWrapper : NSObject

@property (nonatomic, strong) Department *department;
@property (nonatomic, strong) NSArray *experts;

@end

@implementation DepartmentExpertsWrapper

@synthesize department;
@synthesize experts;

@end

@implementation ExpertPickerViewController {
    // search bar
    UISearchBar *_searchBar_;
    // mask view for search mode
    UIView *maskView;
    // tap for mask view
    UITapGestureRecognizer *tapGestureForMaskView;

    // table for experts
    UITableView *tblExperts;
    UITableView *tblExpertSearchResults;

    // experts data source
    NSArray *experts;
    // grouped experts data source
    NSMutableArray *expertsGroup;

    // expert search results data source
    NSMutableArray *expertSearchResults;

    NSInteger chineseWeekDayToday;
}

@synthesize delegate;

- (void)initUI {
    [super initUI];

    // override super view's background view color
    self.view.backgroundColor = [UIColor whiteColor];

    // create search bar
    _searchBar_ = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
    _searchBar_.placeholder = NSLocalizedString(@"search", @"");
    _searchBar_.barStyle = UIBarStyleDefault;
    _searchBar_.delegate = self;
    if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
        _searchBar_.tintColor = [UIColor appBackgroundSearchbar];
        // adjust search bar background more flat
        _searchBar_.backgroundImage = [UIColor imageWithColor:[UIColor appBackgroundSearchbar] size:_searchBar_.bounds.size];
    }
    [self.view addSubview:_searchBar_];

    // create expert table
    tblExperts = [[UITableView alloc] initWithFrame:
            CGRectMake(0, _searchBar_.frame.origin.y + _searchBar_.frame.size.height,
                    self.view.bounds.size.width, self.view.bounds.size.height - self.standardTopbarHeight - _searchBar_.bounds.size.height)
            style:UITableViewStylePlain];
    tblExperts.dataSource = self;
    tblExperts.delegate = self;
    [self.view addSubview:tblExperts];

    // create mask view for search mode
    maskView = [[UIView alloc] initWithFrame:tblExperts.frame];
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    tapGestureForMaskView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMaskViewTapGesture:)];
    [maskView addGestureRecognizer:tapGestureForMaskView];

    // expert search results table
    tblExpertSearchResults = [[UITableView alloc] initWithFrame:maskView.bounds style:UITableViewStylePlain];
    tblExpertSearchResults.tag = 2222;
    tblExpertSearchResults.backgroundColor = [UIColor whiteColor];
    tblExpertSearchResults.dataSource = self;
    tblExpertSearchResults.delegate = self;
    tblExpertSearchResults.hidden = YES;
    [maskView addSubview:tblExpertSearchResults];
}

- (void)setUp {
    [super setUp];
    [self refresh];
}

- (void)refresh {
    if(expertsGroup == nil) {
        expertsGroup = [NSMutableArray array];
    } else {
        [expertsGroup removeAllObjects];
    }

    chineseWeekDayToday = [ChineseWeekdayUtils chineseWeekDayToday];

    NSArray *departments = [DepartmentsManager manager].departments;
    if(departments != nil) {
        for(Department *department in departments) {
            NSArray *idleExperts = [department idleExpertsForExpertIdleDate:(1 << (chineseWeekDayToday - 1))];
            DepartmentExpertsWrapper *departmentExpertsWrapper = [[DepartmentExpertsWrapper alloc] init];
            if(idleExperts.count > 0) {
                departmentExpertsWrapper.department = department;
                departmentExpertsWrapper.experts = idleExperts;
                [expertsGroup addObject:departmentExpertsWrapper];
            }
        }
    }

    [tblExperts reloadData];
}


#pragma mark -
#pragma mark Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.tag == 2222) {
        if([_searchBar_ isFirstResponder]) {
            [self resignSearchBar];
        }
    }
}

#pragma mark -
#pragma mark Search Bar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if(maskView.superview == nil) {
        [self.view addSubview:maskView];
    }
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([XXStringUtils isEmpty:searchText]) {
        // remove search result table
        if(tblExperts.hidden) {
            tblExperts.hidden = NO;
            tblExpertSearchResults.hidden = YES;
        }
        tapGestureForMaskView.enabled = YES;
    } else {
        // create and adding search result table if it doesn't exists
        if(expertSearchResults == nil) {
            expertSearchResults = [NSMutableArray array];
        } else {
            [expertSearchResults removeAllObjects];
        }

        if(expertsGroup != nil) {
            for(DepartmentExpertsWrapper *dew in expertsGroup) {
                if(dew.experts != nil) {
                    for(Expert *expert in dew.experts) {
                        if([expert.name isMatchesString:searchText]) {
                            [expertSearchResults addObject:expert];
                        }
                    }
                }
            }
        }

        if(tblExpertSearchResults.hidden) {
            tblExpertSearchResults.hidden = NO;
            tblExperts.hidden = YES;
            tapGestureForMaskView.enabled = NO;
        }

        [tblExpertSearchResults reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    tapGestureForMaskView.enabled = YES;
    if(expertSearchResults != nil) {
        [expertSearchResults removeAllObjects];
    }
    searchBar.text = [XXStringUtils emptyString];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    tblExperts.hidden = NO;
    tblExpertSearchResults.hidden = YES;
    [maskView removeFromSuperview];
}

- (void)handleMaskViewTapGesture:(UITapGestureRecognizer *)tapGesture {
    [self quitSearchMode];
}

- (void)quitSearchMode {
    [self searchBarCancelButtonClicked:_searchBar_];
}

- (void)resignSearchBar {
    [_searchBar_ resignFirstResponder];
    if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
        for (UIView *view in _searchBar_.subviews) {
            for (UIView *subview in view.subviews) {
                if ([subview isKindOfClass:[UIButton class]]) {
                    [((UIButton *)subview) setEnabled:YES];
                    return;
                }
            }
        }
    } else {
        for (UIView *view in _searchBar_.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                ((UIButton *)view).enabled = YES;
            }
        }
    }
}

#pragma mark -
#pragma mark Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == tblExpertSearchResults) return 1;
    if(expertsGroup == nil) return 0;
    return expertsGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == tblExpertSearchResults) return expertSearchResults == nil ? 0 : expertSearchResults.count;
    if(section >= expertsGroup.count) return 0;
    DepartmentExpertsWrapper *dew = [expertsGroup objectAtIndex:section];
    return dew.experts == nil ? 0 : dew.experts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kExpertCellHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView == tblExpertSearchResults) return nil;
    if(section >= expertsGroup.count) return [XXStringUtils emptyString];
    DepartmentExpertsWrapper *dew = [expertsGroup objectAtIndex:section];
    return dew.department == nil ? [XXStringUtils emptyString] : dew.department.name.sourceString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(tableView == tblExpertSearchResults) return 0;
    return 24;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(tableView == tblExpertSearchResults) return nil;
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tblExperts.bounds.size.width, 24)];
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
    ExpertCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[ExpertCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:cellIdentifier expertCellType:ExpertCellTypeIdleTime];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    if(tableView == tblExperts) {
        [cell setExpert:[self expertForIndexPath:indexPath] withIdleDate:1 << (chineseWeekDayToday - 1)];
    } else {
        [cell setExpert:[expertSearchResults objectAtIndex:indexPath.row] withIdleDate:1 << (chineseWeekDayToday - 1)];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Expert *expert = nil;
    if(tableView == tblExperts) {
        expert = [self expertForIndexPath:indexPath];
    } else {
        if(expertSearchResults != nil && indexPath.row < expertSearchResults.count) {
            expert = [expertSearchResults objectAtIndex:indexPath.row];
        }
    }
    if(expert != nil && self.delegate != nil
            && [self.delegate respondsToSelector:@selector(expertPicker:didSelectExpert:)]) {
        [self.delegate expertPicker:self didSelectExpert:expert];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (Expert *)expertForIndexPath:(NSIndexPath *)indexPath {
    if(expertsGroup == nil) return nil;
    if(indexPath.section >= expertsGroup.count) return nil;
    DepartmentExpertsWrapper *dew = [expertsGroup objectAtIndex:indexPath.section];
    if(dew.experts == nil) return nil;
    if(indexPath.row >= dew.experts.count) return nil;
    return [dew.experts objectAtIndex:indexPath.row];
}

@end