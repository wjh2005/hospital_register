//
// Created by Zhao yang on 3/15/14.
//

#import "OutpatientDepartmentPickerViewController.h"
#import "DepartmentsManager.h"
#import "UIColor+Image.h"

@implementation OutpatientDepartmentPickerViewController {
    // search bar
    UISearchBar *_searchBar_;
    // mask view for search mode
    UIView *maskView;
    // tap for mask view
    UITapGestureRecognizer *tapGestureForMaskView;

    // table for departments
    UITableView *tblDepartments;
    // strings collection for each department first letter of name
    NSArray *indexKeys;
    // table for departments search results
    UITableView *tblDepartmentSearchResults;

    // departments data source
    NSArray *departments;
    // grouped departments data source
    NSMutableDictionary *groupedDepartments;

    // department search results data source
    NSMutableArray *departmentSearchResults;
}

@synthesize delegate;
@synthesize departmentType = _departmentType_;

- (instancetype)initWithDepartmentType:(DepartmentType)departmentType {
    self = [super init];
    if(self) {
        self.departmentType = departmentType;
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
}

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

    // create departments table
    tblDepartments = [[UITableView alloc] initWithFrame:
            CGRectMake(0, _searchBar_.frame.origin.y + _searchBar_.frame.size.height,
                       self.view.bounds.size.width, self.view.bounds.size.height - self.standardTopbarHeight - _searchBar_.bounds.size.height)
            style:UITableViewStylePlain];
    tblDepartments.dataSource = self;
    tblDepartments.delegate = self;
    [self.view addSubview:tblDepartments];

    // create mask view for search mode
    maskView = [[UIView alloc] initWithFrame:tblDepartments.frame];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    tapGestureForMaskView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMaskViewTapGesture:)];
    [maskView addGestureRecognizer:tapGestureForMaskView];

    // department search results table
    tblDepartmentSearchResults = [[UITableView alloc] initWithFrame:maskView.bounds style:UITableViewStylePlain];
    tblDepartmentSearchResults.tag = 2222;
    tblDepartmentSearchResults.dataSource = self;
    tblDepartmentSearchResults.delegate = self;
    tblDepartmentSearchResults.hidden = YES;
    [maskView addSubview:tblDepartmentSearchResults];
}

- (void)refresh {
    departments = [[DepartmentsManager manager] departmentsWithDepartmentType:self.departmentType];
    [self groupDepartments];
    [tblDepartments reloadData];
    [tblDepartmentSearchResults reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self refresh];
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
        if(tblDepartments.hidden) {
            tblDepartments.hidden = NO;
            tblDepartmentSearchResults.hidden = YES;
        }
        tapGestureForMaskView.enabled = YES;
    } else {
        // create and adding search result table if it doesn't exists
        if(departmentSearchResults == nil) {
            departmentSearchResults = [NSMutableArray array];
        } else {
            [departmentSearchResults removeAllObjects];
        }

        if(departments != nil) {
            for(int i=0; i<departments.count; i++) {
                Department *department = [departments objectAtIndex:i];
                if([department.name isMatchesString:searchText]) {
                    [departmentSearchResults addObject:department];
                }
             }
        }

        if(tblDepartmentSearchResults.hidden) {
            tblDepartmentSearchResults.hidden = NO;
            tblDepartments.hidden = YES;
            tapGestureForMaskView.enabled = NO;
        }

        [tblDepartmentSearchResults reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    tapGestureForMaskView.enabled = YES;
    if(departmentSearchResults != nil) {
        [departmentSearchResults removeAllObjects];
    }
    searchBar.text = [XXStringUtils emptyString];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    tblDepartments.hidden = NO;
    tblDepartmentSearchResults.hidden = YES;
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

#pragma mark-
#pragma mark Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == tblDepartments) {
        return indexKeys == nil ? 0 : indexKeys.count;
    } else if(tableView == tblDepartmentSearchResults) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == tblDepartments) {
        NSString *indexKey = [indexKeys objectAtIndex:section];
        NSArray *group = [groupedDepartments objectForKey:indexKey];
        return group == nil ? 0 : group.count;
    } else if(tableView == tblDepartmentSearchResults) {
        return departmentSearchResults == nil ? 0 : departmentSearchResults.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView == tblDepartments) {
        return [indexKeys objectAtIndex:section];
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(tableView == tblDepartmentSearchResults) return 0;
    return 24;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(tableView == tblDepartmentSearchResults) return nil;
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tblDepartments.bounds.size.width, 24)];
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

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor appBackgroundYellow];
        cell.textLabel.font = [UIFont systemFontOfSize:16.f];
        cell.textLabel.textColor = [UIColor darkTextColor];
    }

    Department *department = nil;
    if(tableView == tblDepartments) {
        department = [self groupedDepartmentForIndexPath:indexPath];
    } else if(tableView == tblDepartmentSearchResults) {
        department = [self searchableDepartmentForIndexPath:indexPath];
    }

    if(department != nil) {
        cell.textLabel.text = department.name.sourceString;
    } else {
        cell.textLabel.text = [XXStringUtils emptyString];
    }

    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(tableView == tblDepartments) {
        return indexKeys;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Department *department = nil;
    if(tableView == tblDepartments) {
        department = [self groupedDepartmentForIndexPath:indexPath];
    } else if(tableView == tblDepartmentSearchResults) {
        department = [self searchableDepartmentForIndexPath:indexPath];
    }
    if(department != nil) {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(outpatientDepartmentPicker:didSelectDepartment:)]) {
            [self.delegate outpatientDepartmentPicker:self didSelectDepartment:department];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
#pragma mark Methods

- (Department *)groupedDepartmentForIndexPath:(NSIndexPath *)indexPath {
    if(indexKeys == nil || indexPath.section >= indexKeys.count) return nil;
    NSString *indexKey = [indexKeys objectAtIndex:indexPath.section];
    NSArray *group = [groupedDepartments objectForKey:indexKey];
    if(group != nil && indexPath.row < group.count) {
        return [group objectAtIndex:indexPath.row];
    }
    return nil;
}

- (Department *)searchableDepartmentForIndexPath:(NSIndexPath *)indexPath {
    if(departmentSearchResults == nil) return nil;
    if(indexPath.row >= departmentSearchResults.count) return nil;
    return [departmentSearchResults objectAtIndex:indexPath.row];
}

// group departments

- (void)groupDepartments {
    if(groupedDepartments == nil) {
        groupedDepartments = [NSMutableDictionary dictionary];
    } else {
        [groupedDepartments removeAllObjects];
    }

    if(departments == nil || departments.count == 0) return;

    for(int i=0; i<departments.count; i++) {
        Department *department = [departments objectAtIndex:i];
        NSString *firstLetter = [department.name.shortPinyinString substringWithRange:NSMakeRange(0, 1)].uppercaseString;
        NSMutableArray *group = [groupedDepartments objectForKey:firstLetter];
        if(group == nil) {
            group = [NSMutableArray array];
            [groupedDepartments setObject:group forKey:firstLetter];
        }
        [group addObject:department];
    }
    indexKeys = [groupedDepartments.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = obj1;
        NSString *str2 = obj2;
        return [str1 compare:str2];
    }];
}

@end