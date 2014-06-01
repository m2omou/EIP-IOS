//
//  NBAppDelegate.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 12/11/2013.
//  Copyright (c) 2013 neerbyy. All rights reserved.
//

#import "NBAppDelegate.h"
#import "NBTheme.h"
#import "NBPersistanceManager.h"

@implementation NBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self themeAppearance];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Public methods

- (void)loadRootViewController
{
    UIStoryboard *iPhoneStoryboard = [UIStoryboard storyboardWithName:@"iPhoneStoryboard" bundle:nil];
    UIViewController *rootViewController = [iPhoneStoryboard instantiateInitialViewController];
    self.window.rootViewController = rootViewController;
}

- (void)themeAppearance
{
    NBTheme *theme = [NBTheme sharedTheme];

    UIWindow *window = self.window;
    window.tintColor = theme.whiteColor;

    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.barTintColor = theme.lightGreenColor;
    navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: theme.whiteColor,
                                          NSFontAttributeName:[theme.font fontWithSize:20.f]};
    
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    [barButtonItem setTitleTextAttributes:@{NSFontAttributeName: [theme.font fontWithSize:16.f]}
                                 forState:UIControlStateNormal];
    
    UISegmentedControl *segmentedControl = [UISegmentedControl appearance];
    segmentedControl.tintColor = theme.lightGreenColor;
}

@end
