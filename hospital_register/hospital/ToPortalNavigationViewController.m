//
// Created by Zhao yang on 3/25/14.
//

#import "ToPortalNavigationViewController.h"

@implementation ToPortalNavigationViewController {

}

- (void)initUI {
    [super initUI];
    if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
            initWithTitle:NSLocalizedString(@"back_to_portal", @"") style:UIBarButtonItemStylePlain target:self action:@selector(backToRootViewController:)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                initWithImage:[UIImage imageNamed:@"btn_portal"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRootViewController:)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:216.f / 255.f green:220.f / 255.f blue:220.f / 255.f alpha:1.f];
    }
}

- (void)backToRootViewController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end