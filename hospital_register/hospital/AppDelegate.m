//
//  AppDelegate.m
//  hospital
//
//  Created by Zhao yang on 3/11/14.
//

#import "AppDelegate.h"
#import "DepartmentsManager.h"
#import "UIColor+Image.h"

@implementation AppDelegate {
    RootViewController *_rootViewController_;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // initial manager
    [DepartmentsManager manager];

    // create window content
    _rootViewController_ = [[RootViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_rootViewController_];

    // set dateTitle text attribute
    NSDictionary *textAttributes = nil;
    if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
        textAttributes = @{
                    UITextAttributeTextColor : [UIColor appFontDarkGray],
                    UITextAttributeFont : [UIFont boldSystemFontOfSize:18.f]
                    };
    } else {
        textAttributes = @{
                           UITextAttributeTextColor : [UIColor appFontDarkGray],
                           UITextAttributeFont : [UIFont boldSystemFontOfSize:18.f],
                           UITextAttributeTextShadowColor : [UIColor clearColor]
                           };
    }
    navigationController.navigationBar.titleTextAttributes = textAttributes;

    // set bar background color
    if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
        navigationController.navigationBar.barTintColor = [UIColor appBackgroundTopbar];

        // bar button color for ios7, default is blue
        // navigationController.navigationBar.tintColor = [UIColor redColor];
    } else {
        // make ios 6 more flat
        [navigationController.navigationBar setBackgroundImage:
                [UIColor imageWithColor:[UIColor appBackgroundTopbar] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 44)]
                forBarMetrics:UIBarMetricsDefault];

        // tint color
        navigationController.navigationBar.tintColor = [UIColor colorWithRed:216.f / 255.f green:220.f / 255.f blue:220.f / 255.f alpha:1.f];
    }

    // for ios7 and later
    if([navigationController.navigationBar respondsToSelector:@selector(setTranslucent:)]) {
        navigationController.navigationBar.translucent = NO;
    }

    // init and show key window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark Extensions for app delegate

// Get the top view controller on this app
- (UIViewController *)topViewController {
    return [[UIApplication sharedApplication] topViewController:_rootViewController_.navigationController];
}

// Get the root view controller
- (RootViewController *)rootViewController {
    return _rootViewController_;
}

@end
