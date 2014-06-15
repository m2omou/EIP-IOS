//
//  NBMenuTableViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 12/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBAppDelegate.h"
#import "NBMenuTableViewController.h"
#import "NBPersistanceManager.h"
#import "NBMenuTableViewCell.h"
#import <UIViewController+ECSlidingViewController.h>


@interface NBMenuTableViewController ()

@property (strong, nonatomic) NSIndexPath *tmpIndexPath;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end


@implementation NBMenuTableViewController

#pragma mark - View life cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self selectCell];
}

#pragma mark - UIViewController

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NBPersistanceManager *persistanceManager = [NBPersistanceManager sharedManager];

    if (persistanceManager.isConnected || [self canAccessViewControllerWithIdentifierWhenLoggedOut:identifier]) {
        self.tmpIndexPath = nil;
        [self notifyDelegateWithIdentifier:identifier];
    } else {
        NBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate showLoginAlertViewWithViewController:self completion:^{
            if (persistanceManager.isConnected) {
                self.tmpIndexPath = nil;
                [self notifyDelegateWithIdentifier:identifier];
            } else {
                self.selectedIndexPath = self.tmpIndexPath;
                [self selectCell];
            }
        }];
    }
    
    return NO;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001f;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tmpIndexPath = [tableView indexPathForSelectedRow];
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
}

#pragma mark - Convenience methods

- (void)selectCell
{
    [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (BOOL)canAccessViewControllerWithIdentifierWhenLoggedOut:(NSString *)identifier
{
    BOOL isMapViewController = [identifier isEqualToString:@"NBRootNavigationController"];
    return isMapViewController;
}

- (void)notifyDelegateWithIdentifier:(NSString *)identifier
{
    [self.delegate menuTableViewController:self didSelectViewControllerWithIdentifier:identifier];
}

- (void)resetSelection
{
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self selectCell];
}

@end
