//
// Created by Zhao yang on 3/17/14.
//

#import "HtmlView.h"

@implementation HtmlView {
    UIWebView *_webView_;

    UIView *_loadingView_;
    UIActivityIndicatorView *indicatorView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame htmlString:(NSString *)htmlString {
    self = [self initWithFrame:frame];
    if(self) {
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor clearColor];

    _webView_ = [[UIWebView alloc] initWithFrame:self.bounds];
    _webView_.delegate = self;
    _webView_.backgroundColor = [UIColor clearColor];
    _webView_.opaque = NO;

    for (UIView *view in [[[_webView_ subviews] objectAtIndex:0] subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) view.hidden = YES;
    }
    [self addSubview:_webView_];

    _loadingView_ = [[UIView alloc] initWithFrame:self.bounds];

    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 100, 44, 44)];
    indicatorView.backgroundColor = [UIColor clearColor];
    indicatorView.center = CGPointMake(self.bounds.size.width / 2 - 50, self.bounds.size.height / 2);
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_loadingView_ addSubview:indicatorView];

    UILabel *lblLoading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    lblLoading.center = CGPointMake(indicatorView.center.x + 75, indicatorView.center.y);
    lblLoading.backgroundColor = [UIColor clearColor];
    lblLoading.textColor = [UIColor grayColor];
    lblLoading.font = [UIFont systemFontOfSize:17.f];
    lblLoading.text = [NSString stringWithFormat:@"%@...", NSLocalizedString(@"loading", @"")];
    [_loadingView_ addSubview:lblLoading];
}

- (void)loadWithHtmlString:(NSString *)htmlString {
    if(_loadingView_.superview == nil) {
        [self addSubview:_loadingView_];
        [indicatorView startAnimating];
    }
    [_webView_ loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (UIWebView *)webView {
    return _webView_;
}

- (UIView *)loadingView {
    return _loadingView_;
}

#pragma mark -
#pragma mark Web View Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(_loadingView_.superview != nil) {
        [indicatorView stopAnimating];
        [_loadingView_ removeFromSuperview];
    }
}

@end