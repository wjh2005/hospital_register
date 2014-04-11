//
// Created by Zhao yang on 3/31/14.
//

#import "GenderPickerViewController.h"


@implementation GenderPickerViewController {
    UITableView *tblGenders;
}

@synthesize gender = _gender_;
@synthesize delegate;

- (instancetype)initWithGender:(Gender)gender {
    self = [super init];
    if(self) {
        _gender_ = gender;
    }
    return self;
}

- (void)initUI {
    [super initUI];

    tblGenders = [[UITableView alloc] initWithFrame:
            CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.standardTopbarHeight) style:UITableViewStylePlain];
    tblGenders.backgroundColor = [UIColor clearColor];
    tblGenders.delegate = self;
    tblGenders.dataSource = self;
    tblGenders.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 25)];
    tblGenders.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tblGenders];
}

#pragma mark -
#pragma mark Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor appBackgroundYellow];
        cell.textLabel.highlightedTextColor = cell.textLabel.textColor;
    }

    if(indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"male", @"");
        cell.accessoryType = GenderMale == self.gender ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else {
        cell.textLabel.text = NSLocalizedString(@"female", @"");
        cell.accessoryType = GenderFemale == self.gender ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if((indexPath.row == 0 && GenderMale == self.gender)
            || (indexPath.row == 1 && GenderFemale == self.gender)) {
        return;
    }

    Gender newGender = indexPath.row == 0 ? GenderMale : GenderFemale;

    if(self.delegate != nil
            && [self.delegate respondsToSelector:@selector(genderPickerViewController:didSelectGender:)]) {
        [self.delegate genderPickerViewController:self didSelectGender:newGender];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setGender:(Gender)gender {
    _gender_ = gender;
    [tblGenders reloadData];
}

@end