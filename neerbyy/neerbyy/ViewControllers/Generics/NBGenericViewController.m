//
//  NBGenericViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 24/01/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBGenericViewController.h"
#import <UIViewController+ECSlidingViewController.h>
#import <ECSlidingSegue.h>


@interface NBGenericViewController ()

@end


@implementation NBGenericViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    NBTheme *theme = [NBTheme sharedTheme];
    self.view.backgroundColor = theme.whiteColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.hidesNavigationBar)
        self.navigationController.navigationBarHidden = YES;
    
    if (self.viewForShowMenuPanRecognizer != nil)
        [self addMenuPanGestureRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)addMenuPanGestureRecognizer
{
    UIPanGestureRecognizer *menuPanRecognizer = self.slidingViewController.panGesture;
    NSArray *viewGestureRecognizers = self.viewForShowMenuPanRecognizer.gestureRecognizers;
    BOOL alreadyHasMenuGestureRecognizer = [viewGestureRecognizers containsObject:menuPanRecognizer];
    
    if (alreadyHasMenuGestureRecognizer == NO)
        [self.viewForShowMenuPanRecognizer addGestureRecognizer:menuPanRecognizer];
}

#pragma mark - UIViewController

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Public methods - Alert display

- (void)displayAlertWithTitle:(NSString *)title description:(NSString *)description
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Public methods - Menu display

- (void)showSlidingMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

#pragma mark - Properties

@synthesize theme = _theme;
- (NBTheme *)theme
{
    if (_theme == nil)
        _theme = [NBTheme sharedTheme];
    
    return _theme;
}

@synthesize persistanceManager = _persistanceManager;
- (NBPersistanceManager *)persistanceManager
{
    if (_persistanceManager== nil)
        _persistanceManager = [NBPersistanceManager sharedManager];
    
    return _persistanceManager;
}

@end
