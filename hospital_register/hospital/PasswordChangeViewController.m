//
// Created by Zhao yang on 3/24/14.
//

#import "PasswordChangeViewController.h"

@interface TextField : UITextField

@end

@implementation TextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
        return CGRectMake(bounds.origin.x, bounds.origin.y + 9, bounds.size.width - 35, bounds.size.height);
    }
    return [super textRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end

@implementation PasswordChangeViewController {
    UITableView *tblPasswordChange;
    NSMutableArray *textFields;
}

- (void)initUI {
    [super initUI];

    self.title = NSLocalizedString(@"password_modify", @"");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
            initWithTitle:NSLocalizedString(@"done", @"") style:UIBarButtonItemStylePlain target:self action:@selector(submitNewPassword:)];

    CGFloat y = [UIScreen mainScreen].bounds.size.height > 480 ? 30 : 16;
    tblPasswordChange = [[UITableView alloc] initWithFrame:
            CGRectMake(0, y, self.view.bounds.size.width, 44 * 3) style:UITableViewStylePlain];
    tblPasswordChange.dataSource = self;
    tblPasswordChange.delegate = self;
    tblPasswordChange.scrollEnabled = NO;
    [self.view addSubview:tblPasswordChange];

    UILabel *lblTips = [[UILabel alloc] initWithFrame:CGRectMake(20, y == 16 ? 147 : 170, 280, 54)];
    lblTips.numberOfLines = 2;
    lblTips.textAlignment = NSTextAlignmentCenter;
    lblTips.font = [UIFont systemFontOfSize:13.f];
    lblTips.textColor = [UIColor lightGrayColor];
    lblTips.backgroundColor = [UIColor clearColor];
    lblTips.text = NSLocalizedString(@"password_tips", @"");
    [self.view addSubview:lblTips];
}

- (void)submitNewPassword:(id)sender {

}

#pragma mark -
#pragma mark Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font = [UIFont systemFontOfSize:13.f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    TextField *txtField = [[TextField alloc] initWithFrame:CGRectMake(85, 5, 220, 34)];
    txtField.delegate = self;
    txtField.font = [UIFont systemFontOfSize:13.f];
    txtField.secureTextEntry = YES;
    txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell addSubview:txtField];

    if(textFields == nil) {
        textFields = [NSMutableArray array];
    }
    [textFields addObject:txtField];

    if(indexPath.row == 0) {
        txtField.tag = 200;
        txtField.returnKeyType = UIReturnKeyNext;
        cell.textLabel.text = NSLocalizedString(@"old_password", @"");
        txtField.placeholder = NSLocalizedString(@"type_old_password", @"");
        [txtField becomeFirstResponder];
    } else if(indexPath.row == 1) {
        txtField.tag = 300;
        txtField.returnKeyType = UIReturnKeyNext;
        cell.textLabel.text = NSLocalizedString(@"new_password", @"");
        txtField.placeholder = NSLocalizedString(@"type_new_password", @"");
    } else {
        txtField.tag = 400;
        txtField.returnKeyType = UIReturnKeyDone;
        cell.textLabel.text = NSLocalizedString(@"confirm_password", @"");
        txtField.placeholder = NSLocalizedString(@"type_password_again", @"");
    }
    return cell;
}

#pragma mark -
#pragma mark Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(200 == textField.tag) {
        UITextField *nextTextField = [textFields objectAtIndex:1];
        [nextTextField becomeFirstResponder];
    } else if(300 == textField.tag) {
        UITextField *nextTextField = [textFields objectAtIndex:2];
        [nextTextField becomeFirstResponder];
    } else {
        [self submitNewPassword:textField];
    }
    return YES;
}

@end