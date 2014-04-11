//
// Created by Zhao yang on 3/30/14.
//

#import "TextModifyViewController.h"

@interface FullWidthTextField : UITextField

@end

@implementation FullWidthTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
        return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 11, bounds.size.width - 45, bounds.size.height);
    } else {
        return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 1, bounds.size.width - 45, bounds.size.height);
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end

@implementation TextModifyViewController {
    UILabel *lblTipsFooter;
}

@synthesize textField;
@synthesize identifier;
@synthesize userObject;
@synthesize textView;
@synthesize textModifyViewType = _textModifyViewType_;
@synthesize tips = _tips_;

- (instancetype)init {
    self = [super init];
    if(self) {
        self.textModifyViewType = TextModifyViewTypeSingleLine;
        [self initialize];
    }
    return self;
}

- (instancetype)initWithTextModifyViewType:(TextModifyViewType)textModifyViewType {
    self = [super init];
    if(self) {
        self.textModifyViewType = textModifyViewType;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    if(TextModifyViewTypeSingleLine == self.textModifyViewType) {
        self.textField = [[FullWidthTextField alloc] initWithFrame:
                          CGRectMake(0, 25, self.view.bounds.size.width, 42)];
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.backgroundColor = [UIColor appBackgroundWhite];
        [self.view addSubview:self.textField];
        
        lblTipsFooter = [[UILabel alloc] initWithFrame:
                         CGRectMake(20, self.textField.frame.origin.y + self.textField.bounds.size.height + 5, 280, 54)];
        lblTipsFooter.numberOfLines = 2;
        lblTipsFooter.textAlignment = NSTextAlignmentCenter;
        lblTipsFooter.font = [UIFont systemFontOfSize:14.f];
        lblTipsFooter.textColor = [UIColor lightGrayColor];
        lblTipsFooter.backgroundColor = [UIColor clearColor];
        lblTipsFooter.text = self.tips == nil ? [XXStringUtils emptyString] : self.tips;
        [self.view addSubview:lblTipsFooter];
    } else {
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 120)];
        self.textView.backgroundColor = [UIColor appBackgroundWhite];
        self.textView.layer.borderWidth = 1;
        self.textView.font = [UIFont systemFontOfSize:15.f];
        self.textView.layer.borderColor = [UIColor colorWithRed:204.f / 255.f green:204.f / 255.f blue:204.f / 255.f alpha:1.0f].CGColor;
        [self.view addSubview:self.textView];
    }
}

- (void)initUI {
    [super initUI];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
            initWithTitle:NSLocalizedString(@"done", @"") style:UIBarButtonItemStylePlain target:self action:@selector(btnDonePressed:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if(TextModifyViewTypeSingleLine == self.textModifyViewType) {
        if(self.textField != nil) {
            [self.textField becomeFirstResponder];
        }
    } else {
        if(self.textView != nil) {
            [self.textView becomeFirstResponder];
        }
    }
}

- (void)btnDonePressed:(id)sender {
    if(TextModifyViewTypeSingleLine == self.textModifyViewType) {
        if([XXStringUtils isBlank:self.textField.text]) return;
    } else {
        if([XXStringUtils isBlank:self.textView.text]) return;
    }
    if(self.delegate != nil
            && [self.delegate respondsToSelector:@selector(textModifyViewControllerDidConfirm:)]) {
        [self.delegate textModifyViewControllerDidConfirm:self];
    }
}

- (void)setTips:(NSString *)tips {
    _tips_ = tips;
    if(lblTipsFooter != nil) {
        lblTipsFooter.text = _tips_ == nil ? [XXStringUtils emptyString] : _tips_;
    }
}


#pragma mark -
#pragma mark Text View Delegate


@end