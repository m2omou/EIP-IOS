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


@interface NBConversationViewController () <NBNewMessageViewControllerDelegate>

@property (strong, nonatomic) NBMessageListViewController *messageListViewController;

@end


@implementation NBConversationViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString * const kNBMessageListSegue = @"messageListSegue";
    static NSString * const kNBNewMessageSegue = @"newMessageSegue";
    
    if ([segue.identifier isEqualToString:kNBMessageListSegue])
    {
        self.messageListViewController = segue.destinationViewController;
        self.messageListViewController.messages = self.conversation.latestMessages;
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

@end
