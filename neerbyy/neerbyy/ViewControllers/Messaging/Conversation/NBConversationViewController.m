//
//  NBConversationViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBConversationViewController.h"
#import "NBMessageListViewController.h"
#import "NBNewMessageViewController.h"
#import <GAI.h>
#import <GAIFields.h>
#import <GAIDictionaryBuilder.h>

@interface NBConversationViewController () <NBNewMessageViewControllerDelegate>

@property (strong, nonatomic) NBMessageListViewController *messageListViewController;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *messageButton;

@end


@implementation NBConversationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.conversation.recipient currentUserCanSendMessage] == NO) {
        self.navigationItem.rightBarButtonItems = @[];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Convrsation with someone"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString * const kNBMessageListSegue = @"messageListSegue";
    static NSString * const kNBNewMessageSegue = @"newMessageSegue";
    
    if ([segue.identifier isEqualToString:kNBMessageListSegue])
    {
        __weak NBConversationViewController *weakSelf = self;
        self.messageListViewController = segue.destinationViewController;
        self.messageListViewController.messages = self.conversation.latestMessages;
        self.messageListViewController.onMoreData = ^(NBMessage *lastMessage) {
            [weakSelf fetchMessagesSince:lastMessage];
        };
        self.messageListViewController.onReload = ^(NBMessage *firstMessage) {
            [weakSelf fetchMessagesBefore:firstMessage];
        };
    }
    else if ([segue.identifier isEqualToString:kNBNewMessageSegue])
    {
        NBNewMessageViewController *newMessageViewController = segue.destinationViewController;
        newMessageViewController.recipient = self.conversation.recipient;
        newMessageViewController.delegate = self;
    }
}

#pragma mark - NBNewMessageViewControllerDelegate

- (void)newMessageViewController:(NBNewMessageViewController *)newMessageViewController didSendMessage:(NBMessage *)message creatingConversation:(NBConversation *)conversation
{
    [self.messageListViewController addDataAtBottom:message];
    [self.conversation addMessage:message];
    if ([self.delegate respondsToSelector:@selector(conversationViewController:latestMessageDidChange:)])
        [self.delegate conversationViewController:self latestMessageDidChange:message];
}

#pragma mark - Loading messages

- (void)fetchMessagesSince:(NBMessage *)message
{
    NSNumber *conversationIdentifier = self.conversation.identifier;
    NSNumber *messageIdentifier = message.identifier;
    
    NBAPINetworkOperation *messagesOperation = [NBAPIRequest fetchMessagesForConversation:conversationIdentifier sinceId:messageIdentifier];
    [messagesOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NBAPIResponseMessageList *response = (NBAPIResponseMessageList *)operation.APIResponse;
        [self.messageListViewController addDatasAtBottom:response.messages];
        [self.messageListViewController endMoreData];
    } errorHandler:^(NBAPINetworkOperation *operation, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](operation, error);
        [self.messageListViewController endMoreData];
    }];
    [messagesOperation enqueue];
}

- (void)fetchMessagesBefore:(NBMessage *)message
{
    NSNumber *conversationIdentifier = self.conversation.identifier;
    NSNumber *messageIdentifier = message.identifier;
    
    NBAPINetworkOperation *messagesOperation = [NBAPIRequest fetchMessagesForConversation:conversationIdentifier afterId:messageIdentifier];
    [messagesOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NBAPIResponseMessageList *response = (NBAPIResponseMessageList *)operation.APIResponse;
        [self.messageListViewController addDatasAtTop:response.messages];
        [self.messageListViewController endReload];
    } errorHandler:^(NBAPINetworkOperation *operation, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](operation, error);
        [self.messageListViewController endReload];
    }];
    [messagesOperation enqueue];
}

@end
