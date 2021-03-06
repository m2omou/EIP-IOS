//
//  NBMenuViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 21/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBMenuViewController.h"
#import <UIViewController+ECSlidingViewController.h>
#import "UIStoryboard+NBAdditions.h"
#import "NBMenuTableViewController.h"
#import "NBUser.h"
#import <GAI.h>
#import <GAIFields.h>
#import <GAIDictionaryBuilder.h>


@interface NBMenuViewController () <NBMenuTableViewControllerDelegate>

@property (strong, nonatomic) NBMenuTableViewController *menuTableViewController;
@property (strong, nonatomic) NSMutableDictionary *viewControllers;

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *connectionToogleButton;

@end


@implementation NBMenuViewController

#pragma mark - View life cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.viewControllers = [NSMutableDictionary dictionary];
        [self registerForLoginNotifications];
        if (self.persistanceManager.isConnected)
            [self loginWithCurrentUser];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Menu"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)dealloc
{
    [self unregisterForLoginNotifications];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self themeView];
    [self themeNavigationBarInformations];
}


#pragma mark - Theming

- (void)themeView
{
    self.view.backgroundColor = self.theme.lightGrayColor;
}

- (void)themeNavigationBarInformations
{
    BOOL isConnected = self.persistanceManager.isConnected;
    NSString *username;
    NSString *connectionToogleImageName;

    if (isConnected)
    {
        username = self.persistanceManager.currentUser.username;
        connectionToogleImageName = @"navbar-logout";
    }
    else
    {
        username = @"Invité";
        connectionToogleImageName = @"navbar-login";
    }

    self.usernameLabel.textColor = self.theme.whiteColor;
    self.usernameLabel.text = username;
    self.connectionToogleButton.image = [UIImage imageNamed:connectionToogleImageName];
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString * const kMBMenuTableViewSegueIdentifier = @"menuTableViewSegue";
    
    if ([segue.identifier isEqualToString:kMBMenuTableViewSegueIdentifier])
    {
        NBMenuTableViewController *menuTableViewController = (NBMenuTableViewController *)segue.destinationViewController;
        menuTableViewController.delegate = self;
        self.menuTableViewController = menuTableViewController;
    }
}

#pragma mark - MBMenuTableViewControllerDelegate

- (void)menuTableViewController:(NBMenuTableViewController *)menuTableViewController didSelectViewControllerWithIdentifier:(NSString *)identifier
{
    [self showViewControllerWithIdentifier:identifier];
}

#pragma mark - User interactions

- (IBAction)pressedConnectionToogleButton:(id)sender
{
    BOOL isConnected = self.persistanceManager.isConnected;
    
    if (isConnected)
        [self logoutOperation];
    else
        [self presentLoginViewController];
}

#pragma mark - Convenience methods - Login/Logout

- (void)loginWithCurrentUser
{
    NBPersistanceManager *persistanceManager = self.persistanceManager;
    NSString *username = persistanceManager.currentUser.username;
    NSString *password = persistanceManager.currentUserPassword;
    
    NBAPINetworkOperation *loginOperation = [NBAPIRequest loginWithUsername:username password:password];
    
    [loginOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NBAPIResponseUser *response = (NBAPIResponseUser *)operation.APIResponse;
        persistanceManager.currentUser = response.user;
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];

    [loginOperation enqueue];
}

- (void)logoutUser
{
    [NBAPINetworkEngine resetEngine];
    [self.persistanceManager logout];
    self.viewControllers = [NSMutableDictionary dictionary];
    [self resetRootViewController];
}

- (void)logoutOperation
{
    NBAPINetworkOperation *logoutOperation = [NBAPIRequest logout];
    [logoutOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        [self logoutUser];
    } errorHandler:^(NBAPINetworkOperation *operation, NSError *error) {
        [self logoutUser];
    }];
    [logoutOperation enqueue];
}

- (void)presentLoginViewController
{
    UIViewController *loginViewController = [UIStoryboard loginViewController];
    UIViewController *topViewController = self.slidingViewController.topViewController;
    
    [topViewController presentViewController:loginViewController animated:YES completion:^{
        [self resetRootViewController];
    }];
}

- (void)resetRootViewController
{
    static NSString * const kNBRootViewControllerIdentifier = @"NBRootNavigationController";
    UIViewController *viewController = [self loadViewControllerWithIdentifier:kNBRootViewControllerIdentifier];

    self.slidingViewController.topViewController = viewController;
    [self.slidingViewController resetTopViewAnimated:NO];
    
    [self.menuTableViewController resetSelection];
}

- (void)registerForLoginNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(receivedUserStatusNotification:) name:kNBNotificationUserLoggedIn object:nil];
    [notificationCenter addObserver:self selector:@selector(receivedUserStatusNotification:) name:kNBNotificationUserLoggedOut object:nil];
}

- (void)unregisterForLoginNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void)receivedUserStatusNotification:(NSNotification *)notification
{
    [self themeNavigationBarInformations];
}

#pragma mark - Convenience methods - Changing view controller

- (void)showViewControllerWithIdentifier:(NSString *)identifer
{
    UIViewController *viewController = [self loadViewControllerWithIdentifier:identifer];
    
    self.slidingViewController.topViewController = viewController;
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (UIViewController *)loadViewControllerWithIdentifier:(NSString *)identifier
{
    UIViewController *viewController = self.viewControllers[identifier];
    
    if (viewController == nil)
    {
        viewController = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:identifier];
        self.viewControllers[identifier] = viewController;
    }
    
    return viewController;
}

@end
