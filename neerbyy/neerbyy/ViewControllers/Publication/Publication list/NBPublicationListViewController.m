//
//  NBPublicationListViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPublicationListViewController.h"
#import "NBPublicationTableViewCell.h"
#import "NBPublicationViewController.h"
#import "NBPublication.h"

#pragma mark - Constants

static NSString * const kNBPublicationCellIdentifier = @"NBPublicationTableViewCellIdentifier";

#pragma mark -


@interface NBPublicationListViewController ()

@end


@implementation NBPublicationListViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL displayPlace = self.displayPlace;
    self.reuseIdentifier = kNBPublicationCellIdentifier;
    self.onConfigureCell = ^(NBPublicationTableViewCell *cell, NBPublication *associatedPublication, NSUInteger dataIdx)
    {
        [cell configureWithPublication:associatedPublication displayPlace:displayPlace];
    };
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString * const kNBPublicationViewSegueIdentifier = @"publicationViewSegue";
    
    if ([segue.identifier isEqualToString:kNBPublicationViewSegueIdentifier])
    {
        NBPublicationViewController *publicationViewController = (NBPublicationViewController *)segue.destinationViewController;
        publicationViewController.publication = [self selectedPublication];
    }
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBPersistanceManager *persistanceManager = [NBPersistanceManager sharedManager];
    if (persistanceManager.isConnected == NO)
        return NO;
    
    NBPublication *publication = [self publicationAtIndexPath:indexPath];
    NBUser *currentUser = persistanceManager.currentUser;
    BOOL isFromCurrentUser = [publication isFromUser:currentUser];
    return isFromCurrentUser;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
        [self removePublicationAtIndexPath:indexPath];
}

#pragma mark - Properties

- (void)setPublications:(NSArray *)publications
{
    self.data = publications;
}

- (NSArray *)publications
{
    return self.data;
}

- (NBPublication *)selectedPublication
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    return [self publicationAtIndexPath:selectedIndexPath];
}

- (NBPublication *)publicationAtIndexPath:(NSIndexPath *)indexPath
{
    return self.publications[indexPath.row];
}

- (void)removePublicationFromDataSource:(NBPublication *)publication
{
    NSMutableArray *publications = [self.publications mutableCopy];
    [publications removeObject:publication];
    self.publications = [publications copy];
}

#pragma mark - Convenience methods

- (void)removePublicationAtIndexPath:(NSIndexPath *)indexPath
{
    NBPublication *publication = [self publicationAtIndexPath:indexPath];
    NBAPINetworkOperation *deleteOperation = [NBAPIRequest deletePublication:publication.identifier];
    
    [deleteOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        [self removePublicationFromDataSource:publication];
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    [deleteOperation enqueue];
}

@end
