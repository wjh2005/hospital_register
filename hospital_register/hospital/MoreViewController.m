//
// Created by Zhao yang on 3/14/14.
//

#import "MoreViewController.h"
#import "WebViewController.h"
#import "PasswordChangeViewController.h"
#import "FeedbackViewController.h"

@implementation MoreViewController {
    // settings UI
    UITableView *tblMoreSettings;

    // settings data source
    NSArray *settingItems;
}

- (void)initDefaults {
    [super initDefaults];

    // init settings data source
    settingItems = @[NSLocalizedString(@"hospital_navigation", @""),
                     NSLocalizedString(@"password_modify", @""),
                     NSLocalizedString(@"about_us", @""),
                     NSLocalizedString(@"disclaimer_note", @""),
                     NSLocalizedString(@"feedback", @""),
                     NSLocalizedString(@"contact_customer_service", @"")];
}

- (void)initUI {
    [super initUI];

    self.title = NSLocalizedString(@"more", @"");

    tblMoreSettings = [[UITableView alloc] initWithFrame:
            CGRectMake(0, 0, self.view.bounds.size.width,
                       self.view.bounds.size.height - self.standardTopbarHeight) style:UITableViewStyleGrouped];

    if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
        tblMoreSettings.backgroundView = nil;
        tblMoreSettings.backgroundColor = [UIColor clearColor];
    }

    tblMoreSettings.dataSource = self;
    tblMoreSettings.delegate = self;
    [self.view addSubview:tblMoreSettings];
}

- (NSInteger)itemIndexForIndexPath:(NSIndexPath *)indexPath {
    if(indexPath == nil) return -1;

    NSInteger itemIndex = -1;
    if(indexPath.section == 0) {
        itemIndex = 0 + indexPath.row;
    } else if(indexPath.section == 1) {
        itemIndex = 2 + indexPath.row;
    }

    return itemIndex;
}

#pragma mark -
#pragma mark Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 2;
    if(section == 1) return 4;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.textLabel.highlightedTextColor = [UIColor darkTextColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor appBackgroundYellow];
    }

    NSInteger itemIndex = [self itemIndexForIndexPath:indexPath];
    if(itemIndex != -1) {
        cell.textLabel.text = [settingItems objectAtIndex:itemIndex];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 1) return 103;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section == 1) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 103)];
        UIButton *btnLogout = [[UIButton alloc] initWithFrame:CGRectMake(9.5f, 17, 301, 42)];
        [btnLogout setTitle:NSLocalizedString(@"logout", @"") forState:UIControlStateNormal];
        [btnLogout setBackgroundImage:[UIImage imageNamed:@"btn_red"] forState:UIControlStateNormal];
        [btnLogout setBackgroundImage:[UIImage imageNamed:@"btn_red_highlighted"] forState:UIControlStateHighlighted];
        [footView addSubview:btnLogout];
        return footView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            [self.navigationController pushViewController:
                    [[WebViewController alloc] initWithLocalHtmlWithFileName:@"hospital_navigation"] animated:YES];
        } else if(indexPath.row == 1) {
            [self.navigationController pushViewController:[[PasswordChangeViewController alloc] init] animated:YES];
        }
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            [self.navigationController pushViewController:
                    [[WebViewController alloc] initWithLocalHtmlWithFileName:@"about_us"] animated:YES];
        } else if(indexPath.row == 1) {
            [self.navigationController pushViewController:
                    [[WebViewController alloc] initWithLocalHtmlWithFileName:@"disclaimer_note"] animated:YES];
        } else if(indexPath.row == 2) {
            [self.navigationController pushViewController:[[FeedbackViewController alloc] init] animated:YES];
        } else if(indexPath.row == 3) {
            NSString *phoneNumber = @"18699999999";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNumber]]];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end