//
//  AccountRegisterStep3ViewController.m
//  hospital
//
//  Created by Zhao yang on 4/15/14.
//
//

#import "AccountRegisterStep3ViewController.h"
#import "FixedTextField.h"
#import "Account.h"

@interface AccountRegisterStep3ViewController ()

@end

@implementation AccountRegisterStep3ViewController {
    UITableView *tblAccountRegister;
    NSMutableArray *textFields;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initUI {
    [super initUI];
    
    self.title = NSLocalizedString(@"contact_info", @"");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"submit", @"") style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    
    tblAccountRegister = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44 * 2) style:UITableViewStylePlain];
    tblAccountRegister.dataSource = self;
    tblAccountRegister.delegate = self;
    tblAccountRegister.scrollEnabled = NO;
    
    [self.view addSubview:tblAccountRegister];
    
    UILabel *lblTips = [[UILabel alloc] initWithFrame:CGRectMake(20, tblAccountRegister.frame.origin.y + tblAccountRegister.bounds.size.height + 8, 280, 54)];
    lblTips.numberOfLines = 2;
    lblTips.textAlignment = NSTextAlignmentCenter;
    lblTips.font = [UIFont systemFontOfSize:13.f];
    lblTips.textColor = [UIColor lightGrayColor];
    lblTips.backgroundColor = [UIColor clearColor];
    lblTips.text = NSLocalizedString(@"contact_info_tips", @"");
    [self.view addSubview:lblTips];
}

- (void)submit {
    NSString *mobile = [XXStringUtils trim:((UITextField *)[textFields objectAtIndex:0]).text];
    NSString *address = [XXStringUtils trim:((UITextField *)[textFields objectAtIndex:1]).text];
    
    if([XXStringUtils isEmpty:mobile]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"mobile_not_blank", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    if(mobile.length != 11) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"mobile_format_invalid", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    [Account myAccount].mobile = mobile;
    [Account myAccount].address = address;
    
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"being_register", @"") forType:AlertViewTypeWaitting];
    [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(registerSuccess) userInfo:nil repeats:NO];
}

- (void)registerSuccess {
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"account_register_success", @"") forType:AlertViewTypeSuccess];
    [[XXAlertView currentAlertView] delayDismissAlertView];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FixedTextField *txtField = [[FixedTextField alloc] initWithFrame:CGRectMake(95, 5, 210, 34)];
    txtField.delegate = self;
    txtField.font = [UIFont systemFontOfSize:15.f];
    txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell addSubview:txtField];
    
    if(textFields == nil) {
        textFields = [NSMutableArray array];
    }
    [textFields addObject:txtField];
    
    if(indexPath.row == 0) {
        txtField.tag = 200;
        txtField.returnKeyType = UIReturnKeyNext;
        txtField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textLabel.text = NSLocalizedString(@"mobile", @"");
        txtField.placeholder = NSLocalizedString(@"mobile_input_tips", @"");
        [txtField becomeFirstResponder];
    } else if(indexPath.row == 1) {
        txtField.tag = 300;
        txtField.returnKeyType = UIReturnKeyDone;
        txtField.keyboardType = UIKeyboardTypeDefault;
        cell.textLabel.text = NSLocalizedString(@"user_address", @"");
        txtField.placeholder = NSLocalizedString(@"address_input_tips", @"");
    }
    return cell;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField.tag == 200) {
        return range.location <= 10;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self submit];
    return YES;
}

@end
