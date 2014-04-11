//
// Created by Zhao yang on 3/18/14.
//

#import "PersonalCenterViewController.h"

@implementation PersonalCenterViewController {
    UITableView *tblPersonalSettings;
    NSDateFormatter *dateFormatter;
}

- (void)initDefaults {
    [super initDefaults];
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
}

- (void)initUI {
    [super initUI];

    self.title = NSLocalizedString(@"personal_center", @"");

    tblPersonalSettings = [[UITableView alloc] initWithFrame:
            CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.standardTopbarHeight) style:UITableViewStyleGrouped];
    tblPersonalSettings.dataSource = self;
    tblPersonalSettings.delegate = self;
    if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
        tblPersonalSettings.backgroundView = nil;
        tblPersonalSettings.backgroundColor = [UIColor clearColor];
    }

    [self.view addSubview:tblPersonalSettings];
}

#pragma mark -
#pragma mark Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 1;
    } else if(section == 1) {
        return 5;
    } else if(section == 2) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor appBackgroundYellow];

        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.textLabel.highlightedTextColor = [UIColor darkTextColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:17.f];

        if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
            cell.detailTextLabel.textColor = [UIColor appFontGray];
            cell.detailTextLabel.highlightedTextColor = [UIColor appFontGray];
        }

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = [self titleForIndexPath:indexPath];
    if(indexPath.section == 0) {
        cell.detailTextLabel.text = [Account myAccount].clinicCard.cardNumber;
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            cell.detailTextLabel.text = [Account myAccount].name;
        } else if(indexPath.row == 1) {
            cell.detailTextLabel.text = [dateFormatter stringFromDate:[Account myAccount].birth];
        } else if(indexPath.row == 2) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f %@", [Account myAccount].bodyHeight, NSLocalizedString(@"cm", @"")];
        } else if(indexPath.row == 3) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f %@", [Account myAccount].bodyWeight, NSLocalizedString(@"kg", @"")];
        } else if(indexPath.row == 4) {
            if(GenderMale == [Account myAccount].gender) {
                cell.detailTextLabel.text = NSLocalizedString(@"male", @"");
            } else if(GenderFemale == [Account myAccount].gender) {
                cell.detailTextLabel.text = NSLocalizedString(@"female", @"");
            }
        }
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            cell.detailTextLabel.text = [Account myAccount].mobile == nil ? @"" : [Account myAccount].mobile;
        } else if(indexPath.row == 1) {
            cell.detailTextLabel.text = [Account myAccount].address == nil ? @"" : [Account myAccount].address;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *modifyViewController = nil;
    modifyViewController.title = [NSString stringWithFormat:@"%@%@", [self titleForIndexPath:indexPath], NSLocalizedString(@"modify", @"")];
    if(indexPath.section == 0) {
        TextModifyViewController *textModifyViewController = [[TextModifyViewController alloc] init];
        textModifyViewController.delegate = self;
        textModifyViewController.identifier = @"clinicCard";
        textModifyViewController.textField.placeholder = NSLocalizedString(@"clinic_card_number", @"");
        textModifyViewController.tips = NSLocalizedString(@"clinic_card_tips", @"");
        textModifyViewController.textField.keyboardType = UIKeyboardTypeNumberPad;
        textModifyViewController.textField.text = [Account myAccount].clinicCard.cardNumber;
        modifyViewController = textModifyViewController;
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            TextModifyViewController *textModifyViewController = [[TextModifyViewController alloc] init];
            textModifyViewController.delegate = self;
            textModifyViewController.identifier = @"realName";
            textModifyViewController.textField.placeholder = NSLocalizedString(@"real_name", @"");
            textModifyViewController.tips = NSLocalizedString(@"name_tips", @"");
            textModifyViewController.textField.text = [Account myAccount].name;
            modifyViewController = textModifyViewController;
        } else if(indexPath.row == 1) {
            BirthDayPickerView *birthDayPickerView = [[BirthDayPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 0, 0) birthDay:[Account myAccount].birth];
            birthDayPickerView.delegate = self;
            [birthDayPickerView showInView:self.navigationController.view];
        } else if(indexPath.row == 2) {
            TextModifyViewController *textModifyViewController = [[TextModifyViewController alloc] init];
            textModifyViewController.delegate = self;
            textModifyViewController.identifier = @"bodyHeight";
            textModifyViewController.tips = NSLocalizedString(@"height_tips", @"");
            textModifyViewController.textField.placeholder = @"i.e. 175";
            textModifyViewController.textField.keyboardType = UIKeyboardTypeNumberPad;
            textModifyViewController.textField.text = [NSString stringWithFormat:@"%.0f", [Account myAccount].bodyHeight];
            modifyViewController = textModifyViewController;
        } else if(indexPath.row == 3) {
            TextModifyViewController *textModifyViewController = [[TextModifyViewController alloc] init];
            textModifyViewController.delegate = self;
            textModifyViewController.identifier = @"bodyWeight";
            textModifyViewController.tips = NSLocalizedString(@"body_weight_tips", @"");
            textModifyViewController.textField.placeholder = @"i.e. 65";
            textModifyViewController.textField.keyboardType = UIKeyboardTypeNumberPad;
            textModifyViewController.textField.text = [NSString stringWithFormat:@"%.0f", [Account myAccount].bodyWeight];
            modifyViewController = textModifyViewController;
        } else if(indexPath.row == 4) {
            GenderPickerViewController *genderPickerViewController = [[GenderPickerViewController alloc] initWithGender:[Account myAccount].gender];
            genderPickerViewController.delegate = self;
            genderPickerViewController.title = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"user_gender", @""), NSLocalizedString(@"modify", @"")];
            modifyViewController = genderPickerViewController;
        }
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            TextModifyViewController *textModifyViewController = [[TextModifyViewController alloc] init];
            textModifyViewController.delegate = self;
            textModifyViewController.identifier = @"mobile";
            textModifyViewController.tips = NSLocalizedString(@"mobile_tips", @"");
            textModifyViewController.textField.placeholder = NSLocalizedString(@"user_mobile", @"");
            textModifyViewController.textField.keyboardType = UIKeyboardTypePhonePad;
            textModifyViewController.textField.text = [Account myAccount].mobile;
            modifyViewController = textModifyViewController;
        } else if(indexPath.row == 1) {
            TextModifyViewController *textModifyViewController = [[TextModifyViewController alloc] initWithTextModifyViewType:TextModifyViewTypeMultiLine];
            textModifyViewController.title = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"user_address", @""), NSLocalizedString(@"modify", @"")];
            textModifyViewController.delegate = self;
            textModifyViewController.textView.text = [Account myAccount].address;
            modifyViewController = textModifyViewController;
        }
    }
    
    if(modifyViewController != nil) {
        [self.navigationController pushViewController:modifyViewController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return NSLocalizedString(@"clinic_card", @"");
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            return NSLocalizedString(@"user_name", @"");
        } else if(indexPath.row == 1) {
            return NSLocalizedString(@"user_birth", @"");
        } else if(indexPath.row == 2) {
            return  NSLocalizedString(@"user_height", @"");
        } else if(indexPath.row == 3) {
            return  NSLocalizedString(@"user_body_weight", @"");
        } else if(indexPath.row == 4) {
            return NSLocalizedString(@"user_gender", @"");
        }
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            return NSLocalizedString(@"user_mobile", @"");
        } else if(indexPath.row == 1) {
            return NSLocalizedString(@"user_address", @"");
        }
    }
    return [XXStringUtils emptyString];
}

#pragma mark -
#pragma mark Gender Pick View Delegate

- (void)genderPickerViewController:(GenderPickerViewController *)genderPickerViewController didSelectGender:(Gender)gender {
    [Account myAccount].gender = gender;
    [tblPersonalSettings reloadData];
}

#pragma mark -
#pragma mark Text Modify View Delegate

- (void)textModifyViewControllerDidConfirm:(TextModifyViewController *)textModifyViewController {
    if(TextModifyViewTypeMultiLine == textModifyViewController.textModifyViewType) {
        [Account myAccount].address = textModifyViewController.textView.text;
    } else {
        if([@"clinicCard" isEqualToString:textModifyViewController.identifier]) {
            [Account myAccount].clinicCard.cardNumber = textModifyViewController.textField.text;
        } else if([@"realName" isEqualToString:textModifyViewController.identifier]) {
            [Account myAccount].name = textModifyViewController.textField.text;
        } else if([@"bodyHeight" isEqualToString:textModifyViewController.identifier]) {
            [Account myAccount].bodyHeight = textModifyViewController.textField.text.floatValue;
        } else if([@"bodyWeight" isEqualToString:textModifyViewController.identifier]) {
            [Account myAccount].bodyWeight = textModifyViewController.textField.text.floatValue;
        } else if([@"mobile" isEqualToString:textModifyViewController.identifier]) {
            [Account myAccount].mobile = textModifyViewController.textField.text;
        }
    }
    [tblPersonalSettings reloadData];
    [textModifyViewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Birth Day Picker View Delegate

- (void)birthDayPickerView:(BirthDayPickerView *)birthDayPickerView didSelectDate:(NSDate *)date {
    [Account myAccount].birth = date;
    [tblPersonalSettings reloadData];
}

@end