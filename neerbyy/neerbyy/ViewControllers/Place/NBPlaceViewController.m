//
//  NBPlaceViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPlaceViewController.h"
#import "NBPublicationListViewController.h"
#import "NBNewPublicationViewController.h"
#import "NBPublication.h"
#import "NBPlace.h"


@interface NBPlaceViewController () <NBNewPublicationViewControllerDelegate>

@property (strong, nonatomic) NBPublicationListViewController *publicationListViewController;

@end


@implementation NBPlaceViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self updateUI];
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString * const kNBPublicationListSegue = @"EmbedPublicationListSegue";
    static NSString * const kNBNewPublicationSegue = @"ModalPublishSegue";
    
    if ([segue.identifier isEqualToString:kNBPublicationListSegue])
    {
        __weak NBPlaceViewController *weakSelf = self;
        self.publicationListViewController = segue.destinationViewController;
        self.publicationListViewController.onReload = ^(NBPublication *firstPublication) {
            [weakSelf reloadPublicationsSincePublication:firstPublication];
        };
        [self loadPublications];
    }
    else if ([segue.identifier isEqualToString:kNBNewPublicationSegue])
    {
        NBNewPublicationViewController *newPublicationViewController = segue.destinationViewController;
        newPublicationViewController.place = self.place;
        newPublicationViewController.delegate = self;
    }
}

#pragma mark - NBNewPublicationViewControllerDelegate

- (void)newPublicationViewController:(NBNewPublicationViewController *)newPublicationViewController didPublishPublication:(NBPublication *)publication
{
    NSMutableArray *publications = [self.publicationListViewController.publications mutableCopy];
    [publications insertObject:publication atIndex:0];
    self.publicationListViewController.publications = [publications copy];
}

#pragma mark - User interactions

- (IBAction)pressedAddToFavoritesButton:(id)sender
{
}

#pragma mark - Update UI

- (void)updateUI
{
    self.title = self.place.name;
}

#pragma mark - Convenience methods - Load publications

- (void)loadPublications
{
    NBAPINetworkOperation *loadPublicationOperation = [NBAPIRequest fetchPublicationsForPlace:self.place.identifier];
    
    [loadPublicationOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponsePublicationList *response = (NBAPIResponsePublicationList *)completedOperation.APIResponse;

        self.publicationListViewController.publications = response.publications;

    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    
    [loadPublicationOperation enqueue];
}

- (void)reloadPublicationsSincePublication:(NBPublication *)publication
{
    if (publication == nil)
    {
        [self loadPublications];
        return ;
    }

    NBAPINetworkOperation *reloadPublicationOperation = [NBAPIRequest fetchPublicationsForPlace:self.place.identifier sinceId:publication.identifier];
    
    [reloadPublicationOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponsePublicationList *response = (NBAPIResponsePublicationList *)completedOperation.APIResponse;
        
        NSArray *oldPublications = self.publicationListViewController.publications;
        NSArray *newPublications = response.publications;
        if (!newPublications.count)
            return ;
        NSArray *allPublications = [newPublications arrayByAddingObjectsFromArray:oldPublications];
        self.publicationListViewController.publications = allPublications;
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    
    [reloadPublicationOperation enqueue];
}

@end
