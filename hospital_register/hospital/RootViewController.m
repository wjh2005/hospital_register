//
//  RootViewController.m
//  hospital
//
//  Created by Zhao yang on 3/11/14.
//

#import "RootViewController.h"
#import "AccountLoginViewController.h"
#import "GlobalUserAppData.h"

#import "RealtimeQueuingTypePickerViewController.h"
#import "ReportsViewController.h"
#import "IntelligentGuidanceViewController.h"
#import "PersonalCenterViewController.h"
#import "MoreViewController.h"
#import "ToRegisterViewController.h"

static const CGFloat kGroupButtonHeight = 98;
static const CGFloat kGroupButtonsPanelHeight = kGroupButtonHeight * 2 - 2;

@interface GroupButtonEntry : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *imageName;

- (id)initWithIdentifier:(NSString *)identifier imageName:(NSString *)imageName;

@end;

@implementation GroupButtonEntry

@synthesize identifier = _identifier_;
@synthesize imageName = _imageName_;

- (id)initWithIdentifier:(NSString *)identifier imageName:(NSString *)imageName {
    self = [super init];
    if(self) {
        self.identifier = identifier;
        self.imageName = imageName;
    }
    return self;
}

@end

@interface RootViewController ()

@end

@implementation RootViewController

#pragma mark -
#pragma mark Initializations

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];
    
    self.title = NSLocalizedString(@"hospital_name", @"");

    //
    self.navigationController.delegate = self;

    UIImageView *imgBackground = [[UIImageView alloc] initWithFrame:
            CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.standardTopbarHeight - kGroupButtonsPanelHeight)];
    imgBackground.backgroundColor = [UIColor colorWithRed:112.f / 255.f green:166.f / 255.f blue:220.f /255.f alpha:1.0];
    imgBackground.image = [UIImage imageNamed:[UIScreen mainScreen].bounds.size.height > 480 ? @"bg_blue_sky_568" : @"bg_blue_sky"];
    imgBackground.userInteractionEnabled = YES;
    [self.view addSubview:imgBackground];

    XXButton *btnRegister = [[XXButton alloc] initWithFrame:CGRectMake(30, 30, 315.f / 2, 315.f / 2)];
    btnRegister.identifier = @"register";
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_register"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_register_highlighted"] forState:UIControlStateHighlighted];
    [btnRegister addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnRegister.center = CGPointMake(imgBackground.center.x, (imgBackground.bounds.size.height / 2 - 4));
    [imgBackground addSubview:btnRegister];

    [self generateGroupButtonsView];
}

- (void)setUp {
    [super setUp];
    if(![GlobalUserAppData current].hasLogin) {
        [self.navigationController pushViewController:[[AccountLoginViewController alloc] init] animated:NO];
    }
}

- (void)generateGroupButtonsView {
    NSArray *groupButtonEntries = [NSArray arrayWithObjects:
                    [[GroupButtonEntry alloc] initWithIdentifier:@"real-time-queuing" imageName:@"btn_realtime_queuing"],
                    [[GroupButtonEntry alloc] initWithIdentifier:@"report-queries" imageName:@"btn_report_query"],
                    [[GroupButtonEntry alloc] initWithIdentifier:@"medical-order" imageName:@"btn_medical_order_query"],
                    [[GroupButtonEntry alloc] initWithIdentifier:@"intelligent-guidance" imageName:@"btn_intelligent_guidance"],
                    [[GroupButtonEntry alloc] initWithIdentifier:@"personal-center" imageName:@"btn_personal_center"],
                    [[GroupButtonEntry alloc] initWithIdentifier:@"more" imageName:@"btn_more"], nil];

    UIView *groupButtonsPanelView = [[UIView alloc] initWithFrame:
            CGRectMake(0, self.view.bounds.size.height - kGroupButtonsPanelHeight - self.standardTopbarHeight, self.view.bounds.size.width, kGroupButtonsPanelHeight)];

    for(int i=0; i<groupButtonEntries.count; i++) {
        GroupButtonEntry *entry = [groupButtonEntries objectAtIndex:i];

        CGFloat buttonWidth = (i % 3 == 1) ? 108 : 106;
        CGFloat buttonX = 0;
        if(i % 3 == 0) {
            buttonX = 0;
        } else if(i % 3 == 1) {
            buttonX = 106;
        } else {
            buttonX = 214;
        }

        XXButton *btnEntry = [[XXButton alloc] initWithFrame:CGRectMake(
                        buttonX, i <= 2 ? 0 : kGroupButtonHeight, buttonWidth, kGroupButtonHeight)];

        btnEntry.identifier = entry.identifier;
        [btnEntry setBackgroundImage:[UIImage imageNamed:entry.imageName] forState:UIControlStateNormal];
        [btnEntry setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", entry.imageName, @"highlighted"]] forState:UIControlStateHighlighted];
        [btnEntry addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];

        [groupButtonsPanelView addSubview:btnEntry];
    }

    [self.view addSubview:groupButtonsPanelView];
}

- (void)btnPressed:(XXButton *)button {
    UIViewController *controller = nil;
    if([@"register" isEqualToString:button.identifier]) {
        controller = [[ToRegisterViewController alloc] init];
    } else if([@"report-queries" isEqualToString:button.identifier]) {
        controller = [[ReportsViewController alloc] initWithReportType:ReportTypeReport];
    } else if([@"medical-order" isEqualToString:button.identifier]) {
        controller = [[ReportsViewController alloc] initWithReportType:ReportTypeMedicalOrder];
    } else if([@"real-time-queuing" isEqualToString:button.identifier]) {
        controller = [[RealtimeQueuingTypePickerViewController alloc] init];
    } else if([@"intelligent-guidance" isEqualToString:button.identifier]) {
        controller = [[IntelligentGuidanceViewController alloc] init];
    } else if([@"personal-center" isEqualToString:button.identifier]) {
        controller = [[PersonalCenterViewController alloc] init];
    } else if([@"more" isEqualToString:button.identifier]) {
        controller = [[MoreViewController alloc] init];
    }

    if(controller != nil) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark -
#pragma mark Navigation View Controller Delegate

// change the navigation top bar back button's dateTitle from view controller's dateTitle to 'Back' string
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    UIBarButtonItem *btnBackItem = [[UIBarButtonItem alloc] init];
    btnBackItem.title = NSLocalizedString(@"back", @"");
    if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
        // set button text attributes for state normal
        [btnBackItem setTitleTextAttributes:@ {
                UITextAttributeTextColor : [UIColor appFontDarkGray],
                UITextAttributeTextShadowColor : [UIColor clearColor]
        }                          forState:UIControlStateNormal];

        // set button text attributes for state highlighted
        [btnBackItem setTitleTextAttributes:[btnBackItem titleTextAttributesForState:UIControlStateNormal] forState:UIControlStateHighlighted];
    }
    viewController.navigationItem.backBarButtonItem = btnBackItem;
    
    if([viewController isKindOfClass:[AccountLoginViewController class]]) {
        viewController.navigationController.navigationBarHidden = YES;
    } else {
        viewController.navigationController.navigationBarHidden = NO;
    }
}

#pragma mark -
#pragma mark Process Memory Warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
