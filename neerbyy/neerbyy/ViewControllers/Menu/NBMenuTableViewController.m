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

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation NBMenuTableViewController

#pragma mark - View life cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self selectFirstCellOnLoad];
}

#pragma mark - UIViewController

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [self.delegate menuTableViewController:self didSelectViewControllerWithIdentifier:identifier];
    return NO;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001f;
}

#pragma mark - Convenience methods

- (void)selectFirstCellOnLoad
{
    static BOOL hasBeenLoaded = NO;
    
    if (hasBeenLoaded == NO)
    {
        NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:firstCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        hasBeenLoaded = YES;
    }
}

@end
