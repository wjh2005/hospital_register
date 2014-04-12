//
// Created by Zhao yang on 3/14/14.
//

#import <Foundation/Foundation.h>
#import "NavigationViewController.h"

@interface WebViewController : NavigationViewController<UIWebViewDelegate>

- (instancetype)initWithUrl:(NSString *)url;
- (instancetype)initWithLocalHtmlWithFileName:(NSString *)fileName;

- (void)loadWithHtml:(NSString *)htmlString baeURL:(NSURL *)baseURL;

@end