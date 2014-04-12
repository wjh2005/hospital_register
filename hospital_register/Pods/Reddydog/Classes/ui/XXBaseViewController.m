//
//  XXBaseViewController.m
//  funding
//
//  Created by Zhao yang on 12/17/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "XXBaseViewController.h"

#define EMPTY_CONTENT_VIEW_TAG   384
#define LOADING_VIEW_TAG         222

@interface XXBaseViewController ()

@end

@implementation XXBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDefaults];
    [self initUI];
    [self setUp];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDefaults {
}

- (void)initUI {

}

- (void)setUp {
}

#pragma mark -
#pragma mark About first responder

- (void)registerTapGestureToResignKeyboard {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(triggerTapGestureEventForResignKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)triggerTapGestureEventForResignKeyboard:(UIGestureRecognizer *)gesture {
    [self resignFirstResponderFor:self.view];
}

- (void)resignFirstResponderFor:(UIView *)view {
    for (UIView *v in view.subviews) {
        if([v isFirstResponder]) {
            [v resignFirstResponder];
            return;
        }
    }
}

#pragma mark -
#pragma mark Empty Content View

- (void)showLoadingViewWithMessage:(NSString *)message {
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.standardTopbarHeight)];
    loadingView.tag = LOADING_VIEW_TAG;
    loadingView.backgroundColor = self.view.backgroundColor;
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    indicatorView.center = CGPointMake(self.view.center.x - 35, self.view.bounds.size.height / 2 - self.standardTopbarHeight);
    [loadingView addSubview:indicatorView];

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - 15, 0, 120, 30)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor lightGrayColor];
    lbl.font = [UIFont systemFontOfSize:16.f];
    lbl.textAlignment = NSTextAlignmentLeft;;
    lbl.center = CGPointMake(lbl.center.x, indicatorView.center.y);
    [loadingView addSubview:lbl];

    if([XXStringUtils isBlank:message]) {
        lbl.text = NSLocalizedString(@"loading", @"");
    } else {
        lbl.text = message;
    }

    [indicatorView startAnimating];

    [self.view addSubview:loadingView];
}

- (void)removeLoadingView {
    UIView *loadingView = [self.view viewWithTag:LOADING_VIEW_TAG];
    if(loadingView != nil) [loadingView removeFromSuperview];
}

- (void)showEmptyContentViewWithMessage:(NSString *)message {
    UIView *emptyContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.standardTopbarHeight)];
    emptyContentView.tag = EMPTY_CONTENT_VIEW_TAG;
    emptyContentView.backgroundColor = self.view.backgroundColor;
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 30)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor lightGrayColor];
    lbl.font = [UIFont systemFontOfSize:16.f];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.center = CGPointMake(self.view.center.x, self.view.bounds.size.height / 2 - self.standardTopbarHeight);
    [emptyContentView addSubview:lbl];

    if([XXStringUtils isBlank:message]) {
        lbl.text = NSLocalizedString(@"no_content", @"");
    } else {
        lbl.text = message;
    }
    [self.view addSubview:emptyContentView];
}

- (void)removeEmptyContentView {
    UIView *emptyContentView = [self.view viewWithTag:EMPTY_CONTENT_VIEW_TAG];
    if(emptyContentView != nil) [emptyContentView removeFromSuperview];
}

- (CGFloat)standardTopbarHeight {
    if(self.navigationController != nil) {
        if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
            return self.navigationController.navigationBar.bounds.size.height + STATUS_BAR_HEIGHT;
        } else {
            return self.navigationController.navigationBar.bounds.size.height;
        }
    } else {
        return 0;
    }
}

@end
