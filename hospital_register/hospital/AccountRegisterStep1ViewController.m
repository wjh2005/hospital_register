//
//  AccountRegisterStep1ViewController.m
//  hospital
//
//  Created by Zhao yang on 4/15/14.
//
//

#import "AccountRegisterStep1ViewController.h"
#import "AccountRegisterStep2ViewController.h"
#import "HtmlView.h"
#import "PaperBackgroundView.h"

@interface AccountRegisterStep1ViewController ()

@end

@implementation AccountRegisterStep1ViewController {
    HtmlView *_htmlView_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)initUI {
    [super initUI];
    
    self.title = NSLocalizedString(@"register_protocal", @"");
    
    CGFloat contentHeight = [UIScreen mainScreen].bounds.size.height > 480 ? 19 * 19 : 19 * 15;
    PaperBackgroundView *paperBackgroundView = [[PaperBackgroundView alloc] initWithFrame:CGRectMake(14, 0, 0, 19 + contentHeight + 30)];
    [self.view addSubview:paperBackgroundView];
    _htmlView_ = [[HtmlView alloc] initWithFrame:CGRectMake(0, 0, paperBackgroundView.bounds.size.width, paperBackgroundView.bounds.size.height - 30)];
    [paperBackgroundView addSubview:_htmlView_];
    
    UIButton *btnAgreeAndContinue = [[UIButton alloc] initWithFrame:CGRectMake(13, self.view.bounds.size.height - self.standardTopbarHeight - ([UIScreen mainScreen].bounds.size.height <= 480 ? 62 : 70), 280, 77.f / 2)];
    [btnAgreeAndContinue setTitle:NSLocalizedString(@"agree_and_continue", @"") forState:UIControlStateNormal];
    [btnAgreeAndContinue setBackgroundImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
    [btnAgreeAndContinue setBackgroundImage:[UIImage imageNamed:@"btn_blue_highlighted"] forState:UIControlStateHighlighted];
    [btnAgreeAndContinue addTarget:self action:@selector(btnAgreeAndContinuePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAgreeAndContinue];
}

- (void)setUp {
    [super setUp];
    
    // adding local file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"register_protocal" ofType:@"html"];
    NSString *htmlString = [[NSString alloc] initWithData:[[NSData alloc] initWithContentsOfFile:filePath] encoding:NSUTF8StringEncoding];
    [_htmlView_ loadWithHtmlString:htmlString];
}

- (void)btnAgreeAndContinuePressed:(id)sender {
    [self.navigationController pushViewController:[[AccountRegisterStep2ViewController alloc] init] animated:YES];
}

@end
