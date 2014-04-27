//
// Created by Zhao yang on 3/18/14.
//

#import "IntelligentRecommendationViewController.h"
#import "UIColor+Image.h"
#import "WebViewController.h"
#import "UIColor+MoreColor.h"
#import "XXButton.h"

static NSString * const kContentUrl = @"url";

@implementation IntelligentRecommendationViewController {
}

- (void)initUI {
    [super initUI];
    
    self.title = NSLocalizedString(@"intelligent_recommendation", @"");
    
    BOOL moreThan4s = [UIScreen mainScreen].bounds.size.height > 480;
    
    XXButton *btnTop = [[XXButton alloc] initWithFrame:CGRectMake(5, 5, 310, moreThan4s ? 170 : 140)];
    [self.view addSubview:btnTop];
    
    XXButton *btnRightUp = [[XXButton alloc] initWithFrame:CGRectMake(135 + 10, btnTop.frame.origin.y + btnTop.bounds.size.height + 5, 170, moreThan4s ? 157 : 128)];
    
    [self.view addSubview:btnRightUp];
    
    XXButton *btnRightDown = [[XXButton alloc] initWithFrame:
                             CGRectMake(135 + 10, btnRightUp.frame.origin.y + btnRightUp.bounds.size.height + 5, btnRightUp.bounds.size.width, btnRightUp.bounds.size.height)];
    [self.view addSubview:btnRightDown];
    
    XXButton *btnLeft = [[XXButton alloc] initWithFrame:CGRectMake(5, btnRightUp.frame.origin.y, 135, (btnRightUp.bounds.size.height * 2 + 5))];
    
    [self.view addSubview:btnLeft];
    
    [btnTop addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnRightUp addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnRightDown addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [btnTop setParameter:@"http://stackoverflow.com" forKey:kContentUrl];
    UIImage *topImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hospital" ofType:@"jpg"]];
    
    [btnRightUp setParameter:@"http://stackoverflow.com" forKey:kContentUrl];
    UIImage *topRightImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hospital" ofType:@"jpg"]];
    
    [btnLeft setParameter:@"http://stackoverflow.com" forKey:kContentUrl];
    UIImage *leftImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hospital" ofType:@"jpg"]];
    
    [btnRightDown setParameter:@"http://stackoverflow.com" forKey:kContentUrl];
    UIImage *bottomRightImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hospital" ofType:@"jpg"]];

    
    [btnRightUp setBackgroundImage:topRightImage forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:leftImage forState:UIControlStateNormal];
    [btnTop setBackgroundImage:topImage forState:UIControlStateNormal];
    [btnRightDown setBackgroundImage:bottomRightImage forState:UIControlStateNormal];
}

- (void)btnPressed:(XXButton *)sender {
    NSString *url = [sender parameterForKey:kContentUrl];
    WebViewController *webViewController = [[WebViewController alloc] initWithUrl:url];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end