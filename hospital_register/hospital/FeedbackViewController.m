//
// Created by Zhao yang on 3/24/14.
//

#import "FeedbackViewController.h"


@implementation FeedbackViewController {
    UITextView *txtFeedback;
}

- (void)initUI {
    [super initUI];

    self.title = NSLocalizedString(@"feedback", @"");

    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"send", @"")
          style:UIBarButtonItemStylePlain target:self action:@selector(submitFeedback:)];

    txtFeedback = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 147)];
    txtFeedback.layer.borderColor = [UIColor colorWithRed:204.f / 255.f green:204.f / 255.f blue:204.f / 255.f alpha:1.0f].CGColor;
    txtFeedback.layer.borderWidth = 1;
    txtFeedback.font = [UIFont systemFontOfSize:15.f];
    txtFeedback.backgroundColor = [UIColor appBackgroundWhite];
    [self.view addSubview:txtFeedback];

    UILabel *lblTips = [[UILabel alloc] initWithFrame:CGRectMake(10, txtFeedback.frame.origin.y + txtFeedback.bounds.size.height + 7, 300, 30)];
    lblTips.backgroundColor = [UIColor clearColor];
    lblTips.textColor = [UIColor appFontGray];
    lblTips.font = [UIFont systemFontOfSize:15.f];
    lblTips.text = NSLocalizedString(@"type_your_feedback", @"");
    [self.view addSubview:lblTips];
}

- (void)viewWillAppear:(BOOL)animated {
    if(txtFeedback != nil) {
        [txtFeedback becomeFirstResponder];
    }
}

- (void)submitFeedback:(id)sender {
    [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"feedback_success", @"") forType:AlertViewTypeSuccess];
    [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end