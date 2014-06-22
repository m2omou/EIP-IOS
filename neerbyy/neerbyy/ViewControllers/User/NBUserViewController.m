//
//  NBUserViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBUserViewController.h"
#import "NBNewMessageViewController.h"
#import "NBCircleImageView.h"
#import "NBLabel.h"
#import "NBAppDelegate.h"

static NSString * const kNBNewMessageSegue = @"newMessageSegue";

@interface NBUserViewController ()

@property (strong, nonatomic) IBOutlet NBCircleImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet NBLabel *usernameLabel;
@property (strong, nonatomic) IBOutlet NBLabel *realNameLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end


@implementation NBUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.avatarImageView setImageFromURL:self.user.avatarURL placeHolderImage:[UIImage imageNamed:@"img-avatar"]];
    self.usernameLabel.text = self.user.username;
    self.realNameLabel.text = [self.user completeName];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kNBNewMessageSegue])
    {
        NBNewMessageViewController *newMessageViewController = segue.destinationViewController;
        newMessageViewController.recipient = self.user;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:kNBNewMessageSegue])
    {
        if (self.persistanceManager.isConnected)
            return YES;
        else
        {
            NBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate showLoginAlertViewWithViewController:self completion:^{
                if (self.persistanceManager.isConnected)
                    [self performSegueWithIdentifier:identifier sender:sender];
            }];
            return NO;
        }
    }
    return YES;
}

@end
