//
//  AccountLoginViewController.m
//  hospital
//
//  Created by Zhao yang on 4/15/14.
//
//

#import "AccountLoginViewController.h"
#import "AccountRegisterStep1ViewController.h"
#import "UIImage+wiRoundedRectImage.h"
#import "UIColor+Image.h"
#import "GlobalUserAppData.h"

static CGFloat const kTextBoxHeight = 44;
static CGFloat const kTextBoxWidth  = 320;

@interface LoginTextField : UITextField

@end

@implementation LoginTextField {
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
        return CGRectMake(bounds.origin.x + 15, bounds.origin.y + 11, bounds.size.width - 55, bounds.size.height);
    } else {
        return CGRectMake(bounds.origin.x + 15, bounds.origin.y, bounds.size.width - 55, bounds.size.height);
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect superFrame = [super clearButtonRectForBounds:bounds];
    return CGRectMake(superFrame.origin.x - 10, superFrame.origin.y, superFrame.size.width, superFrame.size.height);
}

@end

@interface AccountLoginViewController ()

@end

@implementation AccountLoginViewController {
    UITextField *txtAccount;
    UITextField *txtPassword;
}

@synthesize loginState;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
    self.loginState = LoginStateUnStart;
}

- (void)initUI {
    [super initUI];
    
    [self registerTapGestureToResignKeyboard];
    
    
    // 确定登录按钮黄金位置， 其余UI 元素根据登录按钮来布局
    
    UIButton *btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 264 : 244, 300, 36)];
    btnLogin.center = CGPointMake(self.view.center.x, btnLogin.center.y);
    [btnLogin setTitle:NSLocalizedString(@"account_login", @"") forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [btnLogin addTarget:self action:@selector(btnLoginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
    
    
    // create input box
    
    txtPassword = [[LoginTextField alloc] initWithFrame:CGRectMake(0, btnLogin.frame.origin.y - btnLogin.bounds.size.height - 30, kTextBoxWidth, kTextBoxHeight)];
    txtPassword.placeholder = NSLocalizedString(@"password_input_tips", @"");
    txtPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtPassword.secureTextEntry = YES;
    txtPassword.keyboardType = UIKeyboardTypeASCIICapable;
    txtPassword.backgroundColor = [UIColor whiteColor];
    txtPassword.returnKeyType = UIReturnKeyDone;
    txtPassword.delegate = self;
    [self.view addSubview:txtPassword];
    
    txtAccount = [[LoginTextField alloc] initWithFrame:CGRectMake(0, txtPassword.frame.origin.y - kTextBoxHeight - 1, kTextBoxWidth, kTextBoxHeight)];
    txtAccount.center = CGPointMake(self.view.center.x, txtAccount.center.y);
    txtAccount.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtAccount.placeholder = NSLocalizedString(@"account_input_tips", @"");
    txtAccount.keyboardType = UIKeyboardTypeASCIICapable;
    txtAccount.backgroundColor = [UIColor whiteColor];
    txtAccount.returnKeyType = UIReturnKeyNext;
    txtAccount.delegate = self;
    [self.view addSubview:txtAccount];
    
    
    // logo for login page
    
    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(50, txtAccount.frame.origin.y - 80, 60, 60)];
    imgLogo.center = CGPointMake(self.view.center.x, imgLogo.center.y);
    imgLogo.image = [UIImage createRoundedRectImage:[UIImage imageNamed:@"icon7"] size:CGSizeMake(120, 120) radius:25];
    [self.view addSubview:imgLogo];
    
    
    // create separator lines
    
    UIImage *separatorImage = [UIColor imageWithColor:[UIColor colorWithRed:201.f / 255.f green:199.f / 255.f blue:204.f / 255.f alpha:1.0f] size:CGSizeMake(kTextBoxWidth, 1)];
    
    [self generateSeparatorLineWithFrame:CGRectMake(0, txtAccount.frame.origin.y - 1, kTextBoxWidth, 1) withImage:separatorImage];
    [self generateSeparatorLineWithFrame:CGRectMake(0, txtPassword.frame.origin.y - 1, kTextBoxWidth, 1) withImage:separatorImage];
    [self generateSeparatorLineWithFrame:CGRectMake(0, txtPassword.frame.origin.y + txtPassword.bounds.size.height, kTextBoxWidth, 1) withImage:separatorImage];
    
    // create register or password forgot link button
    
    UILabel *lblSeperator = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, 5, 44)];
    lblSeperator.text = @"|";
    lblSeperator.font = [UIFont systemFontOfSize:17];
    lblSeperator.backgroundColor = [UIColor clearColor];
    lblSeperator.textColor = [UIColor darkGrayColor];
    lblSeperator.center = CGPointMake(self.view.center.x, lblSeperator.center.y);
    [self.view addSubview:lblSeperator];
    
    UIButton *btnForgetPassword = [[UIButton alloc] initWithFrame:CGRectMake(lblSeperator.frame.origin.x - 80, self.view.frame.size.height - 60, 80, 44)];
    [btnForgetPassword setTitle:NSLocalizedString(@"forgot_password", @"") forState:UIControlStateNormal];
    btnForgetPassword.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [btnForgetPassword setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnForgetPassword setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [btnForgetPassword addTarget:self action:@selector(btnForgetPasswordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnForgetPassword];
    
    UIButton *btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(lblSeperator.frame.origin.x + 5, btnForgetPassword.frame.origin.y, 80, 44)];
    btnRegister.tag = 100;
    [btnRegister setTitle:NSLocalizedString(@"account_register", @"") forState:UIControlStateNormal];
    btnRegister.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btnRegister setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnRegister setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnRegister addTarget:self action:@selector(btnRegisterOrPasswordForgotPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRegister];
}

- (void)btnLoginPressed:(id)sender {
    if([XXStringUtils isBlank:txtAccount.text]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"username_not_blank", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    if([XXStringUtils isBlank:txtPassword.text]) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"password_not_blank", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    if(LoginStateUnStart != self.loginState) return;
    self.loginState = LoginStateLogging;
    
    NSString *account = [XXStringUtils trim:txtAccount.text];
    NSString *password = [XXStringUtils trim:txtPassword.text];
    
    if([@"demo" isEqualToString:account.lowercaseString] && [@"demo" isEqualToString:password.lowercaseString]) {
        
//        __weak NSTimer *wTimer = timer;
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"being_login", @"") forType:AlertViewTypeWaitting];
        [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
        [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(loginSuccess) userInfo:nil repeats:NO];
        /*
        [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO cancelledBlock:^{
            if(LoginStateLogging != self.loginState) return;
            self.loginState = LoginStateCancelling;
            
            if(wTimer != nil) {
                __strong NSTimer *sTimer = wTimer;
                if(sTimer != nil && sTimer.isValid) {
                    [sTimer invalidate];
                }
            }
            
            self.loginState = LoginStateUnStart;
            
            [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"login_cancelled", @"") forType:AlertViewTypeSuccess showCancellButton:NO];
            [[XXAlertView currentAlertView] delayDismissAlertView];
        }];
         */
    } else {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"name_or_password_invalid", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        [self loginFailed];
    }
}

- (void)btnRegisterOrPasswordForgotPressed:(UIButton *)sender {
    // create register step 1 view controller

    UIViewController *presentedViewController = nil;
    
    if(sender.tag == 100) {
        presentedViewController = [[AccountRegisterStep1ViewController alloc] init];
    }
    
    if(presentedViewController == nil) return;
    
    UIBarButtonItem *btnBackItem = [[UIBarButtonItem alloc] init];
    btnBackItem.title = NSLocalizedString(@"cancel", @"");
    btnBackItem.target = self;
    btnBackItem.action = @selector(cancel);
    if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
        // set button text attributes for state normal
        [btnBackItem setTitleTextAttributes:@ {
            UITextAttributeTextColor : [UIColor appFontDarkGray],
            UITextAttributeTextShadowColor : [UIColor clearColor]
        }                          forState:UIControlStateNormal];
        
        // set button text attributes for state highlighted
        [btnBackItem setTitleTextAttributes:[btnBackItem titleTextAttributesForState:UIControlStateNormal] forState:UIControlStateHighlighted];
    }
    presentedViewController.navigationItem.leftBarButtonItem = btnBackItem;
    
    
    //create navigation view controller
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:presentedViewController];
    
    // set dateTitle text attribute
    NSDictionary *textAttributes = nil;
    if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
        textAttributes = @{
                           UITextAttributeTextColor : [UIColor appFontDarkGray],
                           UITextAttributeFont : [UIFont boldSystemFontOfSize:18.f]
                           };
    } else {
        textAttributes = @{
                           UITextAttributeTextColor : [UIColor appFontDarkGray],
                           UITextAttributeFont : [UIFont boldSystemFontOfSize:18.f],
                           UITextAttributeTextShadowColor : [UIColor clearColor]
                           };
    }
    navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    // set bar background color
    if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
        navigationController.navigationBar.barTintColor = [UIColor appBackgroundTopbar];
        
        // bar button color for ios7, default is blue
        // navigationController.navigationBar.tintColor = [UIColor redColor];
    } else {
        // make ios 6 more flat
        [navigationController.navigationBar setBackgroundImage:
         [UIColor imageWithColor:[UIColor appBackgroundTopbar] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 44)]
                                                 forBarMetrics:UIBarMetricsDefault];
        
        // tint color
        navigationController.navigationBar.tintColor = [UIColor colorWithRed:216.f / 255.f green:220.f / 255.f blue:220.f / 255.f alpha:1.f];
    }
    
    // for ios7 and later
    if([navigationController.navigationBar respondsToSelector:@selector(setTranslucent:)]) {
        navigationController.navigationBar.translucent = NO;
    }
    
    [self presentViewController:navigationController animated:YES completion:^{ }];
}

- (void)generateSeparatorLineWithFrame:(CGRect)frame withImage:(UIImage *)separatorImage {
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:frame];
    imgLine.image = separatorImage;
    [self.view addSubview:imgLine];
}

#pragma mark -
#pragma mark 

- (void)loginSuccess {
    if(LoginStateLogging != self.loginState) return;
    self.loginState = LoginStateUnStart;
    [GlobalUserAppData current].loginAccount = [XXStringUtils trim:txtAccount.text];
    [[GlobalUserAppData current] save];
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"login_success", @"") forType:AlertViewTypeSuccess showCancellButton:NO];
    [[XXAlertView currentAlertView] delayDismissAlertView];
    [self dismissViewControllerAnimated:NO completion:^{ }];
}

- (void)loginFailed {
    self.loginState = LoginStateUnStart;
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

#pragma mark -
#pragma mark Text Field Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(txtPassword == textField) {
        return range.location <= 18;
    } else {
        return range.location <= 30;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == txtAccount) {
        if(txtPassword != nil) {
            [txtPassword becomeFirstResponder];
        }
    } else if(textField == txtPassword) {
        [self btnLoginPressed:textField];
    }
    return YES;
}

@end
