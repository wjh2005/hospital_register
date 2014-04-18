//
//  AccountRegisterStep2ViewController.m
//  hospital
//
//  Created by Zhao yang on 4/15/14.
//
//

#import "AccountRegisterStep2ViewController.h"
#import "AccountRegisterStep3ViewController.h"
#import "FixedTextField.h"
#import "Account.h"

@interface AccountRegisterStep2ViewController ()

@end

@implementation AccountRegisterStep2ViewController {
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
    
    self.title = NSLocalizedString(@"basic_info", @"");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next_step", @"") style:UIBarButtonItemStylePlain target:self action:@selector(btnNextPressed:)];
    
    tblAccountRegister = [[UITableView alloc] initWithFrame:CGRectMake(0, 28, self.view.bounds.size.width, 44 * 3) style:UITableViewStylePlain];
    tblAccountRegister.dataSource = self;
    tblAccountRegister.delegate = self;
    tblAccountRegister.scrollEnabled = NO;
    
    [self.view addSubview:tblAccountRegister];
    
    UILabel *lblTips = [[UILabel alloc] initWithFrame:CGRectMake(20, tblAccountRegister.frame.origin.y + tblAccountRegister.bounds.size.height + 8, 280, 27)];
    lblTips.textAlignment = NSTextAlignmentCenter;
    lblTips.font = [UIFont systemFontOfSize:13.f];
    lblTips.textColor = [UIColor lightGrayColor];
    lblTips.backgroundColor = [UIColor clearColor];
    lblTips.text = NSLocalizedString(@"basic_info_register_tips", @"");
    [self.view addSubview:lblTips];
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
        txtField.keyboardType = UIKeyboardTypeASCIICapable;
        cell.textLabel.text = NSLocalizedString(@"account", @"");
        txtField.placeholder = NSLocalizedString(@"type_login_account", @"");
        [txtField becomeFirstResponder];
    } else if(indexPath.row == 1) {
        txtField.tag = 300;
        txtField.returnKeyType = UIReturnKeyNext;
        txtField.keyboardType = UIKeyboardTypeDefault;
        [txtField addTarget:self action:@selector(textFieldEventEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.textLabel.text = NSLocalizedString(@"name", @"");
        txtField.placeholder = NSLocalizedString(@"type_real_name", @"");
    } else if(indexPath.row == 2){
        txtField.tag = 400;
        txtField.returnKeyType = UIReturnKeyDone;
        txtField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textLabel.text = NSLocalizedString(@"clinic_card_number", @"");
        txtField.placeholder = NSLocalizedString(@"type_clinic_card", @"");
    }
    return cell;
}

- (void)btnNextPressed:(id)sender {
    
    NSString *account = [XXStringUtils trim:((UITextField *)[textFields objectAtIndex:0]).text];
    NSString *name = [XXStringUtils trim:((UITextField *)[textFields objectAtIndex:1]).text];
    NSString *clinicCard = [XXStringUtils trim:((UITextField *)[textFields objectAtIndex:2]).text];
    
    if([XXStringUtils isEmpty:account]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"account_not_blank", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    if([XXStringUtils isEmpty:name]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"name_not_blank", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    if([XXStringUtils isEmpty:clinicCard]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"clinic_card_not_blank", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    [Account myAccount].account = account;
    [Account myAccount].name = name;
    [Account myAccount].clinicCard.cardNumber = clinicCard;
    
    [self.navigationController pushViewController:[[AccountRegisterStep3ViewController alloc] init] animated:YES];
}

#pragma mark -
#pragma mark Text View Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField.tag == 200) {
        return range.location <= 18;
    } else if(textField.tag == 400) {
        return range.location <= 18;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(200 == textField.tag) {
        UITextField *nextTextField = [textFields objectAtIndex:1];
        [nextTextField becomeFirstResponder];
    } else if(300 == textField.tag) {
        UITextField *nextTextField = [textFields objectAtIndex:2];
        [nextTextField becomeFirstResponder];
    }
    return YES;
}

- (void)textFieldEventEditingChanged:(UITextField *)sender {
    UITextRange *markRange = sender.markedTextRange;
    NSInteger pos = [sender offsetFromPosition:markRange.start toPosition:markRange.end];
    NSInteger nLength = sender.text.length - pos;
    if (nLength > 4 && pos==0) {
        sender.text = [sender.text substringToIndex:4];
    }
}

@end
