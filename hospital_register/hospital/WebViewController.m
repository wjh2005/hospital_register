//
// Created by Zhao yang on 3/14/14.
//

#import "WebViewController.h"

@implementation WebViewController {
    // will displayed html file name
    NSString *_file_name_;
    
    // will displayed html url
    NSString *_url_;
    
    UITapGestureRecognizer *tapGesture;

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

- (instancetype)initWithUrl:(NSString *)url {
    self = [self init];
    if(self) {
        _url_ = url;
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
    } else if(![XXStringUtils isBlank:_url_]) {
        [self loadPageWithUrl:[NSURL URLWithString:_url_]];
    } else {
        [self showEmptyContentViewWithMessage:NSLocalizedString(@"no_data", @"")];
    }
}

- (void)loadWithHtml:(NSString *)htmlString baeURL:(NSURL *)baseURL {
    [self showLoadingViewWithMessage:nil];
    [_webView_ loadHTMLString:htmlString baseURL:baseURL];
}

- (void)loadWithHtmlWithoutLoadingView:(NSString *)htmlString baeURL:(NSURL *)baseURL {
    [_webView_ loadHTMLString:htmlString baseURL:baseURL];
}

- (void)loadPageWithUrl:(NSURL *)url {
    if(url == nil) return;
    [self showLoadingViewWithMessage:nil];
    __weak WebViewController *wself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(wself == nil) return;

        NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
        NSHTTPURLResponse *response;
        NSError *error;
        
        // send sync request
        NSData *body = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if(error == nil && response != nil && response.statusCode == 200 && body != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(wself == nil) return;
                __strong WebViewController *sself = wself;
                [sself loadWithHtmlWithoutLoadingView:[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] baeURL:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(wself == nil) return;
                __strong WebViewController *sself = wself;
                [sself loadWasFailed];
            });
#ifdef DEBUG
            NSLog(@"Load Url [%@] Failed, Status code is %d, Error [%@]", _url_, response != nil ? response.statusCode : -1, error.description);
#endif
        }
    });
}

- (void)loadWasFailed {
    [self removeLoadingView];
    [self showEmptyContentViewWithMessage:NSLocalizedString(@"retry_loading", @"")];
    if(tapGesture == nil) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadPage)];
    }
    [self.view addGestureRecognizer:tapGesture];
}

- (void)reloadPage {
    [self.view removeGestureRecognizer:tapGesture];
    [self removeEmptyContentView];
    [self loadPageWithUrl:[NSURL URLWithString:_url_]];
}

#pragma mark -
#pragma mark Web View Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *requestURL = [request URL];
    if(![XXStringUtils isBlank:_file_name_]) {
        if (
            ([[requestURL scheme] isEqualToString:@"http" ] || [[requestURL scheme] isEqualToString:@"https" ] || [[requestURL scheme] isEqualToString:@"mailto"])
            &&
            (navigationType == UIWebViewNavigationTypeLinkClicked)) {
            return ![[UIApplication sharedApplication ] openURL:requestURL];
        }
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self removeLoadingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self removeLoadingView];
}

@end