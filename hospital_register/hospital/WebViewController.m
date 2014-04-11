//
// Created by Zhao yang on 3/14/14.
//

#import "WebViewController.h"

@implementation WebViewController {
    // will displayed html file name
    NSString *_file_name_;

    // content view
    UIWebView *_webView_;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _file_name_ = nil;
    }
    return self;
}

- (instancetype)initWithLocalHtmlWithFileName:(NSString *)fileName {
    self = [self init];
    if(self) {
        _file_name_ = fileName;
    }
    return self;
}

- (void)initUI {
    [super initUI];
    self.title = NSLocalizedString(_file_name_, @"");
    _webView_ = [[UIWebView alloc] initWithFrame:CGRectMake(
            0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.standardTopbarHeight)];
    _webView_.delegate = self;
    [self.view addSubview:_webView_];
}

- (void)setUp {
    [super setUp];
    if(![XXStringUtils isBlank:_file_name_]) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:_file_name_ ofType:@"html"];
        if(resourcePath != nil) {
            NSData *dataOfHtmlFile = [NSData dataWithContentsOfFile:resourcePath];
            if(dataOfHtmlFile != nil) {
                NSString *htmlString = [[NSString alloc] initWithData:dataOfHtmlFile encoding:NSUTF8StringEncoding];
                [self loadWithHtml:htmlString baeURL:[NSBundle mainBundle].bundleURL];
            }
        }
    }
}

- (void)loadWithHtml:(NSString *)htmlString baeURL:(NSURL *)baseURL {
    [self showLoadingViewWithMessage:nil];
    [_webView_ loadHTMLString:htmlString baseURL:baseURL];
}

#pragma mark -
#pragma mark Web View Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *requestURL = [request URL];
    if (
        ([[requestURL scheme] isEqualToString:@"http" ] || [[requestURL scheme] isEqualToString:@"https" ] || [[requestURL scheme] isEqualToString:@"mailto"])
        &&
        (navigationType == UIWebViewNavigationTypeLinkClicked)) {
        return ![[UIApplication sharedApplication ] openURL:requestURL];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self removeLoadingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self removeLoadingView];
}

@end