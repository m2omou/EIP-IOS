//
//  NBAppDelegate.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 12/11/2013.
//  Copyright (c) 2013 neerbyy. All rights reserved.
//

#import "NBAppDelegate.h"
#import <UIViewController+ECSlidingViewController.h>
#import "NBTheme.h"
#import "NBPersistanceManager.h"
#import "NBLoginViewController.h"
#import "UIStoryboard+NBAdditions.h"
#import "NBTutorialViewController.h"
#import "NBMenuViewController.h"

@interface NBAppDelegate () <UIAlertViewDelegate>

@property (weak, nonatomic) UIViewController *viewControllerForLoginPresentation;
@property (strong, nonatomic) void (^onLoginPresentationCompletion)();

@end

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
    
    persistanceManager.hasSeenTutorial = YES;

    NBTutorialViewController *tutorialViewController = [UIStoryboard tutorialViewController];
    [self presentLoginViewControllerOnViewController:self.window.rootViewController animated:NO completion:^{
        [self.window.rootViewController.presentedViewController presentViewController:tutorialViewController animated:NO completion:nil];
    }];
}

- (void)presentLoginViewControllerOnViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)())completion
{
    UINavigationController *loginNavigationViewController = [UIStoryboard loginViewController];
    NBLoginViewController *loginViewController = loginNavigationViewController.viewControllers.firstObject;
    loginViewController.onDismiss = self.onLoginPresentationCompletion;
    [viewController presentViewController:loginNavigationViewController animated:animated completion:completion];
}

- (void)showLoginAlertViewWithViewController:(UIViewController *)viewController completion:(void (^)())completion
{
    self.viewControllerForLoginPresentation = viewController;
    self.onLoginPresentationCompletion = completion;
    [[[UIAlertView alloc] initWithTitle:@"Connectez-vous !"
                                message:@"Cette fonctionnalité nécessite d'avoir un compte Neerbyy"
                               delegate:self
                      cancelButtonTitle:@"Annuler"
                      otherButtonTitles:@"Connexion", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [self presentLoginViewControllerOnViewController:self.viewControllerForLoginPresentation animated:YES completion:^{
            self.viewControllerForLoginPresentation = nil;
        }];
    }
    else
    {
        self.onLoginPresentationCompletion();
        self.viewControllerForLoginPresentation = nil;
    }
}

- (void)logoutUser
{
    ECSlidingViewController *slidingViewController = (ECSlidingViewController *)self.window.rootViewController;
    NSAssert(slidingViewController && [slidingViewController isKindOfClass:[ECSlidingViewController class]], @"Couldn't get sliding view controller");
    
    UINavigationController *menuNavigationViewController = (UINavigationController *)slidingViewController.underLeftViewController;
    NSAssert(menuNavigationViewController && [menuNavigationViewController isKindOfClass:[UINavigationController class]], @"Couldn't get menu view controller");

    NBMenuViewController *menuViewController = (NBMenuViewController *)menuNavigationViewController.viewControllers.firstObject;
    NSAssert(menuViewController && [menuViewController isKindOfClass:[NBMenuViewController class]], @"Couldn't get menu view controller");
    
    [menuViewController logoutUser];
}

@end
