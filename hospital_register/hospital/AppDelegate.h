//
//  AppDelegate.h
//  hospital
//
//  Created by Zhao yang on 3/11/14.
//
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (RootViewController *)rootViewController;
- (UIViewController *)topViewController;

@end
