//
//  NBGenericViewController.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 24/01/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBAPI.h"
#import "NBTheme.h"
#import "NBPersistanceManager.h"
#import "NBButton.h"


@interface NBGenericViewController : UIViewController

@property (weak, nonatomic) NBTheme *theme;
@property (weak, nonatomic) NBPersistanceManager *persistanceManager;

@property (assign, nonatomic) BOOL hidesNavigationBar;

@property (weak, nonatomic) IBOutlet UIView *viewForShowMenuPanRecognizer;
- (IBAction)showSlidingMenu:(id)sender;

- (void)displayAlertWithTitle:(NSString *)title description:(NSString *)description;

@end
