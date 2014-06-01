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
#import "NSString+DataFormatting.h"

@interface NBPlaceViewController () <NBNewPublicationViewControllerDelegate>

@property (strong, nonatomic) NBPublicationListViewController *publicationListViewController;
@property (strong, nonatomic) IBOutlet NBLabel *distanceLabel;
@property (strong, nonatomic) IBOutlet NBPrimaryButton *followButton;

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
        self.publicationListViewController.onMoreData = ^(NBPublication *lastPublication) {
            [weakSelf loadPublicationsAfterPublication:lastPublication];
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
    if (self.place.isFollowedByCurrentUser)
        [self unfollowCurrentPlace];
    else
        [self followCurrentPlace];
}

#pragma mark - Update UI

- (void)updateUI
{
    CLLocationCoordinate2D userLocation = self.persistanceManager.lastKnownLocation;
    CLLocationDistance distance = [self.place distanceFrom:userLocation];
    NSString *distanceString = [NSString stringForDistance:distance prefix:@"À "];

    self.title = self.place.name;
    self.distanceLabel.textColor = self.theme.lightGreenColor;
    self.distanceLabel.text = distanceString;
    
    UIImage *followImage;
    if (self.place.isFollowedByCurrentUser)
        followImage = [UIImage imageNamed:@"ic-fav-remove"];
    else
        followImage = [UIImage imageNamed:@"ic-fav-add"];
    [self.followButton setImage:followImage forState:UIControlStateNormal];
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
        [self.publicationListViewController endReload];
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    
    [reloadPublicationOperation enqueue];
}

- (void)loadPublicationsAfterPublication:(NBPublication *)publication
{
    if (publication == nil)
        return ;
    
    NBAPINetworkOperation *loadMorePublicationsOperation = [NBAPIRequest fetchPublicationsForPlace:self.place.identifier afterId:publication.identifier];
    
    [loadMorePublicationsOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponsePublicationList *response = (NBAPIResponsePublicationList *)completedOperation.APIResponse;
        
        NSArray *oldPublications = self.publicationListViewController.publications;
        NSArray *newPublications = response.publications;
        if (!newPublications.count)
            return ;
        NSArray *allPublications = [oldPublications arrayByAddingObjectsFromArray:newPublications];
        self.publicationListViewController.publications = allPublications;
        [self.publicationListViewController endMoreData];
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    
    [loadMorePublicationsOperation enqueue];
}

- (void)followCurrentPlace
{
    NBAPINetworkOperation *followOp = [NBAPIRequest followPlace:self.place.identifier];
    
    [followOp addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NBAPIResponsePlace *response = (NBAPIResponsePlace *)operation.APIResponse;
        self.place.followingId = response.place.followingId;
        [self updateUI];
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    
    [followOp enqueue];
}

- (void)unfollowCurrentPlace
{
    NBAPINetworkOperation *unfollowOp = [NBAPIRequest unfollowPlace:self.place.followingId];
    
    [unfollowOp addCompletionHandler:^(NBAPINetworkOperation *operation) {
        self.place.followingId = nil;
        [self updateUI];
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    
    [unfollowOp enqueue];
}

@end
