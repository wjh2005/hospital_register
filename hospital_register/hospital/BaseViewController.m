//
//  BaseViewController.m
//  hospital
//
//  Created by Zhao yang on 3/11/14.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)initUI {
    [super initUI];
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor appBackgroundGray];
}

@end
