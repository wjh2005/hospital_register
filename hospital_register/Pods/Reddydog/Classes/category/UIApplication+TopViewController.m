//
//  UIApplication+TopViewController.m
//  securityguards
//
//  Created by Zhao yang on 12/31/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UIApplication+TopViewController.h"

@implementation UIApplication (TopViewController)

- (UIViewController *)topViewController:(UIViewController *)rootViewController {
    if(rootViewController == nil) return nil;

    UIViewController *controller =
            rootViewController.presentedViewController == nil ? rootViewController : rootViewController.presentedViewController;

    if([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationViewController = (UINavigationController *)controller;
        UIViewController *viewController = [navigationViewController.viewControllers lastObject];
        if(viewController == nil) return navigationViewController;
        return [self topViewController:viewController];
    } else if([controller isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)controller;
        if(tabBarController.selectedViewController == nil) return tabBarController;
        [self topViewController:tabBarController.selectedViewController];
    }

    if(controller.presentedViewController == nil) {
        return controller;
    }

    return [self topViewController:controller.presentedViewController];
}

@end
