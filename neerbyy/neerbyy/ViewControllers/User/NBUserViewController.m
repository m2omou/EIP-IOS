//
//  NBUserViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBUserViewController.h"
#import "NBPublicationListViewController.h"
#import "NBPlaceListViewController.h"
#import "NBNewMessageViewController.h"
#import "NBCircleImageView.h"
#import "NBLabel.h"
#import "NBPublication.h"
#import "NBAppDelegate.h"
#import "NBPlace.h"

static NSString * const kNBNewMessageSegue = @"newMessageSegue";

@interface NBUserViewController ()

@property (strong, nonatomic) NBPublicationListViewController *publicationListViewController;
@property (strong, nonatomic) NBPlaceListViewController *placeListViewController;
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
    if ([self.user currentUserCanSendMessage] == NO) {
        self.navigationItem.rightBarButtonItems = @[];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString * const kNBPlaceListSegue = @"placeList";
    static NSString * const kNBSouvenirListSegue = @"souvenirList";

    __weak NBUserViewController *weakSelf = self;
    if ([segue.identifier isEqualToString:kNBNewMessageSegue])
    {
        NBNewMessageViewController *newMessageViewController = segue.destinationViewController;
        newMessageViewController.recipient = self.user;
    }
    else if ([segue.identifier isEqualToString:kNBPlaceListSegue])
    {
        self.placeListViewController = segue.destinationViewController;
        self.placeListViewController.onReload = ^(NBPlace *firstPlace) {
            [weakSelf loadPlacesSincePlace:firstPlace];
        };
        self.placeListViewController.onMoreData = ^(NBPlace *lastPlace) {
            [weakSelf loadPlacesAfterPlace:lastPlace];
        };        [self loadPlaces];
    }
    else if ([segue.identifier isEqualToString:kNBSouvenirListSegue])
    {
        self.publicationListViewController = segue.destinationViewController;
        self.publicationListViewController.onReload = ^(NBPublication *firstPublication) {
            [weakSelf loadSouvenirsSinceSouvenir:firstPublication];
        };
        self.publicationListViewController.onMoreData = ^(NBPublication *lastPublication) {
            [weakSelf loadSouvenirsAfterSouvenir:lastPublication];
        };
        [self loadSouvenirs];
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

- (void)loadSouvenirs
{
    NBAPINetworkOperation *souvenirsOp = [NBAPIRequest fetchPublicationsForUser:self.user.identifier];
    [souvenirsOp addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NSArray *souvenirs = ((NBAPIResponsePublicationList *)operation.APIResponse).publications;
        self.publicationListViewController.publications = souvenirs;
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    [souvenirsOp enqueue];
}

- (void)loadSouvenirsSinceSouvenir:(NBPublication *)publication
{
    if (publication == nil)
    {
        [self loadSouvenirs];
        return;
    }

    NBAPINetworkOperation *reloadSouvenirsOp = [NBAPIRequest fetchPublicationsForUser:self.user.identifier sinceId:publication.identifier];
    
    [reloadSouvenirsOp addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponsePublicationList *response = (NBAPIResponsePublicationList *)completedOperation.APIResponse;
        
        [self.publicationListViewController addDatasAtTop:response.publications];
        [self.publicationListViewController endReload];
    } errorHandler:^(NBAPINetworkOperation *failedOp, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](failedOp, error);
        [self.publicationListViewController endReload];
    }];
    
    [reloadSouvenirsOp enqueue];}

- (void)loadSouvenirsAfterSouvenir:(NBPublication *)publication
{
    if (publication == nil)
    {
        [self.publicationListViewController endMoreData];
        return ;
    }
    
    NBAPINetworkOperation *loadMorePlacesOperation = [NBAPIRequest fetchPublicationsForUser:self.user.identifier afterId:publication.identifier];
    
    [loadMorePlacesOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponsePublicationList *response = (NBAPIResponsePublicationList *)completedOperation.APIResponse;
        
        NSArray *newPublications = response.publications;
        if (!newPublications.count)
            return ;
        [self.publicationListViewController addDatasAtBottom:newPublications];
        [self.publicationListViewController endMoreData];
    } errorHandler:^(NBAPINetworkOperation *failedOp, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](failedOp, error);
        [self.publicationListViewController endMoreData];
    }];
    
    [loadMorePlacesOperation enqueue];
}

- (void)loadPlaces
{
    NBAPINetworkOperation *placesOp = [NBAPIRequest fetchFollowedPlacesForUser:self.user.identifier];
    [placesOp addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NSArray *places = ((NBAPIResponsePlaceList *)operation.APIResponse).places;
        self.placeListViewController.places = places;
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    [placesOp enqueue];
}

- (void)loadPlacesSincePlace:(NBPlace *)place
{
    if (place == nil)
    {
        [self loadPlaces];
        return ;
    }
    
    NBAPINetworkOperation *reloadPlacesOperation = [NBAPIRequest fetchFollowedPlacesForUser:self.user.identifier sinceId:place.identifier];
    
    [reloadPlacesOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponsePlaceList *response = (NBAPIResponsePlaceList *)completedOperation.APIResponse;
        
        [self.placeListViewController addDatasAtTop:response.places];
        [self.placeListViewController endReload];
    } errorHandler:^(NBAPINetworkOperation *failedOp, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](failedOp, error);
        [self.placeListViewController endReload];
    }];
    
    [reloadPlacesOperation enqueue];
}

- (void)loadPlacesAfterPlace:(NBPlace *)place
{
    if (place == nil)
    {
        [self.placeListViewController endMoreData];
        return ;
    }
    
    NBAPINetworkOperation *loadMorePlacesOperation = [NBAPIRequest fetchFollowedPlacesForUser:self.user.identifier afterId:place.identifier];
    
    [loadMorePlacesOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponsePlaceList *response = (NBAPIResponsePlaceList *)completedOperation.APIResponse;
        
        NSArray *newPlaces = response.places;
        if (!newPlaces.count)
            return ;
        [self.placeListViewController addDatasAtBottom:newPlaces];
        [self.placeListViewController endMoreData];
    } errorHandler:^(NBAPINetworkOperation *failedOp, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](failedOp, error);
        [self.placeListViewController endMoreData];
    }];
    
    [loadMorePlacesOperation enqueue];
}

@end
