//
//  NBMessagingViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBMessagingViewController.h"
#import "NBConversationListViewController.h"
#import "NBConversation.h"
#import "NBMessage.h"
#import <GAI.h>
#import <GAIFields.h>
#import <GAIDictionaryBuilder.h>


@interface NBMessagingViewController ()

@property (strong, nonatomic) NBConversationListViewController *converstationListViewController;

@end


@implementation NBMessagingViewController

#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"List of conversation"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString * const kNBPublicationListSegue = @"conversationList";
    
    if ([segue.identifier isEqualToString:kNBPublicationListSegue])
    {
        __weak NBMessagingViewController *weakSelf = self;
        self.converstationListViewController = segue.destinationViewController;
        self.converstationListViewController.onReload = ^(NBConversation *firstConversation) {
            [weakSelf reloadConversationsSinceConversation:firstConversation];
        };
        self.converstationListViewController.onMoreData = ^(NBConversation *lastConversation) {
            [weakSelf loadConversationsAfterConversation:lastConversation];
        };
        [self loadConversations];
    }
}

#pragma mark - Loading feed

- (void)loadConversations
{
    NBAPINetworkOperation *loadConversationsOperation = [NBAPIRequest fetchConversations];
    
    [loadConversationsOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponseConversationList *response = (NBAPIResponseConversationList *)completedOperation.APIResponse;
        
        self.converstationListViewController.conversations = response.conversations;
        [self.converstationListViewController endReload];
    } errorHandler:^(NBAPINetworkOperation *failedOp, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](failedOp, error);
        [self.converstationListViewController endReload];
    }];
    
    [loadConversationsOperation enqueue];
}

- (void)reloadConversationsSinceConversation:(NBConversation *)conversation
{
    if (conversation == nil)
    {
        [self loadConversations];
        return ;
    }
    
    NBAPINetworkOperation *reloadConversationsOperation = [NBAPIRequest fetchConversationsSinceId:conversation.identifier];
    
    [reloadConversationsOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponseConversationList *response = (NBAPIResponseConversationList *)completedOperation.APIResponse;
        [self.converstationListViewController addDatasAtTop:response.conversations];
        [self.converstationListViewController endReload];
    } errorHandler:^(NBAPINetworkOperation *failedOp, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](failedOp, error);
        [self.converstationListViewController endReload];
    }];
    
    [reloadConversationsOperation enqueue];
}

- (void)loadConversationsAfterConversation:(NBConversation *)conversation
{
    if (conversation == nil)
    {
        [self.converstationListViewController endMoreData];
        return ;
    }
    
    NBAPINetworkOperation *loadMoreConversationsOperation = [NBAPIRequest fetchConversationsAfterId:conversation.identifier];
    
    [loadMoreConversationsOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponseConversationList *response = (NBAPIResponseConversationList *)completedOperation.APIResponse;
        [self.converstationListViewController addDatasAtBottom:response.conversations];
        [self.converstationListViewController endMoreData];
    } errorHandler:^(NBAPINetworkOperation *failedOp, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](failedOp, error);
        [self.converstationListViewController endMoreData];
    }];
    
    [loadMoreConversationsOperation enqueue];
}

@end
