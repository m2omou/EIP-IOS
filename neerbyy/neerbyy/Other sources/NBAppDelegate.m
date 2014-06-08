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
#import "NBLoginViewController.h"
#import "UIStoryboard+NBAdditions.h"
#import "NBTutorialViewController.h"

@implementation NBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self themeAppearance];
    [self.window makeKeyAndVisible];
    [self presentTutorialIfNeeded];
    return YES;
}

#pragma mark - Convenience methods

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

- (void)presentTutorialIfNeeded
{
    NBPersistanceManager *persistanceManager = [NBPersistanceManager sharedManager];
    BOOL hasSeenTutorial = persistanceManager.hasSeenTutorial;
    
    if (hasSeenTutorial)
        return ;

    UINavigationController *loginViewController = [UIStoryboard loginViewController];
    NBTutorialViewController *tutorialViewController = [UIStoryboard tutorialViewController];
    [self.window.rootViewController presentViewController:loginViewController animated:NO completion:^{
        [loginViewController presentViewController:tutorialViewController animated:NO completion:nil];
    }];
    
}

@end
