//
//  NBFavoritesViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBFavoritesViewController.h"
#import "NBPlaceListViewController.h"
#import "NBPlace.h"

@interface NBFavoritesViewController ()

@property (strong, nonatomic) NBPlaceListViewController *placesListViewController;

@end


@implementation NBFavoritesViewController

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString * const kNBPlacesListSegue = @"EmbedPlacesListSegue";
    
    if ([segue.identifier isEqualToString:kNBPlacesListSegue])
    {
        __weak NBFavoritesViewController *weakSelf = self;
        self.placesListViewController = segue.destinationViewController;
        self.placesListViewController.onReload = ^(NBPlace *firstPlace) {
            [weakSelf reloadFollowedPlacesSincePlace:firstPlace];
        };
        self.placesListViewController.onMoreData = ^(NBPlace *lastPlace) {
            [weakSelf loadFollowedPlacesAfterPlace:lastPlace];
        };
        [self loadFollowedPlaces];
    }
}

#pragma mark - Convenience methods - Load places

- (void)loadFollowedPlaces
{
    NBAPINetworkOperation *loadPlacesOperation = [NBAPIRequest fetchFollowedPlaces];
    
    [loadPlacesOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponsePlaceList *response = (NBAPIResponsePlaceList *)completedOperation.APIResponse;
        
        self.placesListViewController.places = response.places;
        [self.placesListViewController endReload];
    } errorHandler:^(NBAPINetworkOperation *failedOp, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](failedOp, error);
        [self.placesListViewController endReload];
    }];
    
    [loadPlacesOperation enqueue];
}

- (void)reloadFollowedPlacesSincePlace:(NBPlace *)place
{
    if (place == nil)
    {
        [self loadFollowedPlaces];
        return ;
    }
    
    NBAPINetworkOperation *reloadPlacesOperation = [NBAPIRequest fetchFollowedPlacesSinceId:place.followingId];
    
    [reloadPlacesOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponsePlaceList *response = (NBAPIResponsePlaceList *)completedOperation.APIResponse;
        
        NSArray *oldPlaces = self.placesListViewController.places;
        NSArray *newPlaces = response.places;
        if (newPlaces.count > 0)
        {
            NSArray *allPlaces = [newPlaces arrayByAddingObjectsFromArray:oldPlaces];
            self.placesListViewController.places = allPlaces;
        }
        [self.placesListViewController endReload];
    } errorHandler:^(NBAPINetworkOperation *failedOp, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](failedOp, error);
        [self.placesListViewController endReload];
    }];
    
    [reloadPlacesOperation enqueue];
}

- (void)loadFollowedPlacesAfterPlace:(NBPlace *)place
{
    if (place == nil)
    {
        [self.placesListViewController endMoreData];
        return ;
    }
    
    NBAPINetworkOperation *loadMorePlacesOperation = [NBAPIRequest fetchFollowedPlacesAfterId:place.followingId];
    
    [loadMorePlacesOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponsePlaceList *response = (NBAPIResponsePlaceList *)completedOperation.APIResponse;
        
        NSArray *oldPlaces = self.placesListViewController.places;
        NSArray *newPlaces = response.places;
        if (!newPlaces.count)
            return ;
        NSArray *allPlaces = [oldPlaces arrayByAddingObjectsFromArray:newPlaces];
        self.placesListViewController.places = allPlaces;
        [self.placesListViewController endMoreData];
    } errorHandler:^(NBAPINetworkOperation *failedOp, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](failedOp, error);
        [self.placesListViewController endMoreData];
    }];
    
    [loadMorePlacesOperation enqueue];
}

@end
