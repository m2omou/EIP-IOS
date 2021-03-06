//
//  NBConfigurationTableViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 29/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBConfigurationTableViewController.h"
#import "NBSettings.h"
#import "NBAPI.h"
#import "NBPersistanceManager.h"
#import "NBUser.h"
#import "NBTheme.h"
#import <GAI.h>
#import <GAIFields.h>
#import <GAIDictionaryBuilder.h>


@interface NBConfigurationTableViewController ()

@property (strong, nonatomic) IBOutlet UISwitch *commentNotificationSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *allowContactSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *messageNotificationSwitch;

@end

@implementation NBConfigurationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self themeSwitches];
    [self updateSwitches];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Configuration"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)themeSwitches
{
    self.commentNotificationSwitch.onTintColor =
    self.allowContactSwitch.onTintColor =
    self.messageNotificationSwitch.onTintColor = [NBTheme sharedTheme].lightGreenColor;
    
    self.commentNotificationSwitch.on =
    self.messageNotificationSwitch.on = NO;
    
    self.commentNotificationSwitch.enabled =
    self.messageNotificationSwitch.enabled = NO;
}

- (void)updateSwitches
{
    NBSettings *settings = [NBPersistanceManager sharedManager].currentUser.settings;
    
    self.allowContactSwitch.on = settings.canBeContactedByOtherUsers;
    self.commentNotificationSwitch.on = settings.receivesNotificationOnComments;
    self.messageNotificationSwitch.on = settings.receivesNotificationOnMessages;
}

- (IBAction)toogledCommentNotification:(id)sender
{
    [self updateSettings];
}

- (IBAction)toogledAllowContact:(id)sender
{
    [self updateSettings];
}

- (IBAction)toogledMessageNotification:(id)sender
{
    [self updateSettings];
}

- (void)updateSettings
{
    BOOL allowContact = self.allowContactSwitch.isOn;
    BOOL commentNotif = self.commentNotificationSwitch.isOn;
    BOOL messageNotif = self.messageNotificationSwitch.isOn;
    
    NBSettings *settings = [NBPersistanceManager sharedManager].currentUser.settings;
    settings.canBeContactedByOtherUsers = allowContact;
    settings.receivesNotificationOnComments = commentNotif;
    settings.receivesNotificationOnMessages = messageNotif;
    
    [self updateWithSettings:settings];
}

- (void)updateWithSettings:(NBSettings *)settings
{
    NBAPINetworkOperation *operation = [NBAPIRequest updateSettings:settings];

    [operation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        [NBPersistanceManager sharedManager].currentUser.settings = settings;
    } errorHandler:^(NBAPINetworkOperation *operation, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](operation, error);
        [self updateSwitches];
    }];
    [operation enqueue];
}

@end
