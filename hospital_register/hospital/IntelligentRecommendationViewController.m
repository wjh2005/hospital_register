//
// Created by Zhao yang on 3/18/14.
//

#import "IntelligentRecommendationViewController.h"
#import "UIColor+Image.h"
#import "WebViewController.h"
#import "UIColor+MoreColor.h"
#import "XXButton.h"

@implementation IntelligentRecommendationViewController {

}

- (void)initUI {
    [super initUI];

    self.title = NSLocalizedString(@"intelligent_recommendation", @"");
    
    BOOL moreThan4s = [UIScreen mainScreen].bounds.size.height > 480;
    
    XXButton *btnTop = [[XXButton alloc] initWithFrame:CGRectMake(5, 5, 310, moreThan4s ? 170 : 140)];
    [btnTop setBackgroundImage:[UIColor imageWithColor:[UIColor appADGreen] size:CGSizeMake(btnTop.bounds.size.width * 2, btnTop.bounds.size.height * 2)] forState:UIControlStateNormal];
    [self.view addSubview:btnTop];
    
    XXButton *btnRightUp = [[XXButton alloc] initWithFrame:CGRectMake(135 + 10, btnTop.frame.origin.y + btnTop.bounds.size.height + 5, 170, moreThan4s ? 157 : 128)];
    [btnRightUp setBackgroundImage:[UIColor imageWithColor:[UIColor appADRed] size:CGSizeMake(btnRightUp.bounds.size.width * 2, btnRightUp.bounds.size.height * 2)] forState:UIControlStateNormal];
    [self.view addSubview:btnRightUp];
    
    XXButton *btnRightDown = [[XXButton alloc] initWithFrame:
                             CGRectMake(135 + 10, btnRightUp.frame.origin.y + btnRightUp.bounds.size.height + 5, btnRightUp.bounds.size.width, btnRightUp.bounds.size.height)];
    [btnRightDown setBackgroundImage:[UIColor imageWithColor:[UIColor appADOrange] size:CGSizeMake(btnRightDown.bounds.size.width * 2, btnRightDown.bounds.size.height * 2)] forState:UIControlStateNormal];
    [self.view addSubview:btnRightDown];
    
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(5, btnRightUp.frame.origin.y, 135, (btnRightUp.bounds.size.height * 2 + 5))];
    [btnLeft setBackgroundImage:[UIColor imageWithColor:[UIColor appADBlue] size:CGSizeMake(btnLeft.bounds.size.width * 2, btnLeft.bounds.size.height * 2)] forState:UIControlStateNormal];
    [self.view addSubview:btnLeft];
    
    [btnTop addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnRightUp addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnRightDown addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnPressed:(UIButton *)sender {
    WebViewController *webViewController = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController showEmptyContentViewWithMessage:NSLocalizedString(@"no_data", @"")];
}

@end