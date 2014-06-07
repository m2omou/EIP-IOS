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

@interface NBFeedViewController ()

@property (strong, nonatomic) NBPublicationListViewController *publicationListViewController;

@end

@implementation NBFeedViewController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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
        
        NSArray *oldPublications = self.publicationListViewController.publications;
        NSArray *newPublications = response.publications;
        if (newPublications.count > 0)
        {
            NSArray *allPublications = [newPublications arrayByAddingObjectsFromArray:oldPublications];
            self.publicationListViewController.publications = allPublications;
        }
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
        [self.publicationListViewController endMoreData];
        
        NSArray *oldPublications = self.publicationListViewController.publications;
        NSArray *newPublications = response.publications;
        if (!newPublications.count)
            return ;
        NSArray *allPublications = [oldPublications arrayByAddingObjectsFromArray:newPublications];
        self.publicationListViewController.publications = allPublications;
    } errorHandler:^(NBAPINetworkOperation *failedOp, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](failedOp, error);
        [self.publicationListViewController endMoreData];
    }];
    
    [loadMorePublicationsOperation enqueue];
}

@end
