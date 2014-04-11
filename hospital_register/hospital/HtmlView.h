//
// Created by Zhao yang on 3/17/14.
//

#import <Foundation/Foundation.h>


@interface HtmlView : UIView<UIWebViewDelegate>

- (id)initWithFrame:(CGRect)frame htmlString:(NSString *)htmlString;

- (void)loadWithHtmlString:(NSString *)htmlString;

- (UIWebView *)webView;
- (UIView *)loadingView;

@end