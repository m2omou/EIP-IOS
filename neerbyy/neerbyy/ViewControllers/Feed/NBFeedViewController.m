//
//  NBFeedViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBFeedViewController.h"
#import "NBPublicationListViewController.h"
#import "NBPublication.h"
#import "NBPlace.h"

@interface NBFeedViewController ()

@property (strong, nonatomic) NBPublicationListViewController *publicationListViewController;

@end

@implementation NBFeedViewController

#pragma mark - View life cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self registerForNotifications];
    }
    
    return self;
}

- (void)dealloc
{
    [self unregisterForNotifications];
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString * const kNBPublicationListSegue = @"publicationList";
    
    if ([segue.identifier isEqualToString:kNBPublicationListSegue])
    {
        __weak NBFeedViewController *weakSelf = self;
        self.publicationListViewController = segue.destinationViewController;
        self.publicationListViewController.onReload = ^(NBPublication *firstPublication) {
            [weakSelf reloadPublicationsSincePublication:firstPublication];
        };
        self.publicationListViewController.onMoreData = ^(NBPublication *lastPublication) {
            [weakSelf loadPublicationsAfterPublication:lastPublication];
        };
        self.publicationListViewController.displayPlace = YES;
        [self loadFeed];
    }
}

#pragma mark - Loading feed

- (void)loadFeed
{
    NBAPINetworkOperation *loadPublicationOperation = [NBAPIRequest fetchFlow];
    
    [loadPublicationOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponsePublicationList *response = (NBAPIResponsePublicationList *)completedOperation.APIResponse;
        
        self.publicationListViewController.publications = response.publications;
        [self.publicationListViewController endReload];
    } errorHandler:^(NBAPINetworkOperation *failedOp, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](failedOp, error);
        [self.publicationListViewController endReload];
    }];
    
    [loadPublicationOperation enqueue];
}

- (void)reloadPublicationsSincePublication:(NBPublication *)publication
{
    if (publication == nil)
    {
        [self loadFeed];
        return ;
    }
    
    NBAPINetworkOperation *reloadPublicationOperation = [NBAPIRequest fetchFlowSinceId:publication.identifier];
    
    [reloadPublicationOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponsePublicationList *response = (NBAPIResponsePublicationList *)completedOperation.APIResponse;
        [self.publicationListViewController addDatasAtTop:response.publications];
        [self.publicationListViewController endReload];
    } errorHandler:^(NBAPINetworkOperation *failedOp, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](failedOp, error);
        [self.publicationListViewController endReload];
    }];
    
    [reloadPublicationOperation enqueue];
}

- (void)loadPublicationsAfterPublication:(NBPublication *)publication
{
    if (publication == nil)
    {
        [self.publicationListViewController endMoreData];
        return ;
    }
    
    NBAPINetworkOperation *loadMorePublicationsOperation = [NBAPIRequest fetchFlowAfterId:publication.identifier];
    
    [loadMorePublicationsOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponsePublicationList *response = (NBAPIResponsePublicationList *)completedOperation.APIResponse;
        [self.publicationListViewController addDatasAtBottom:response.publications];
        [self.publicationListViewController endMoreData];
    } errorHandler:^(NBAPINetworkOperation *failedOp, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](failedOp, error);
        [self.publicationListViewController endMoreData];
    }];
    
    [loadMorePublicationsOperation enqueue];
}

#pragma mark - Notifications

- (void)registerForNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(userDidUnfollowPlaceWithNotification:) name:kNBNotificationPlaceUnfollowed object:nil];
}

- (void)unregisterForNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

- (void)userDidUnfollowPlaceWithNotification:(NSNotification *)notification
{
    NBPlace *place = notification.object;
    NSArray *publications = [self.publicationListViewController.publications copy];
    for (NBPublication *publication in publications)
    {
        if ([publication.place.identifier isEqualToString:place.identifier])
        {
            [self.publicationListViewController removeData:publication];
        }
    }
}

@end
