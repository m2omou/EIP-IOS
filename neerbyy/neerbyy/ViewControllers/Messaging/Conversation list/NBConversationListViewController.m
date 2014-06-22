//
//  NBConversationListViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBConversationListViewController.h"
#import "NBConversationTableViewCell.h"
#import "NBConversationViewController.h"


#pragma mark - Constants

static NSString * const kNBConversationCellIdentifier = @"NBConversationTableViewCellIdentifier";

#pragma mark -


@interface NBConversationListViewController () <NBConversationViewControllerDelegate>

@end


@implementation NBConversationListViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reuseIdentifier = kNBConversationCellIdentifier;
    self.onConfigureCell = ^(NBConversationTableViewCell *cell, id associatedConversation, NSUInteger dataIdx)
    {
        [cell configureWithConversation:associatedConversation];
    };
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString * const kNBMessagesListSegue = @"messagesViewController";

    if ([segue.identifier isEqualToString:kNBMessagesListSegue])
    {
        NBConversationViewController *conversationViewController = segue.destinationViewController;
        conversationViewController.conversation = [self selectedConversation];
        conversationViewController.delegate = self;
    }
}

#pragma mark - NBConversationViewControllerDelegate

- (void)conversationViewController:(NBConversationViewController *)conversationViewController latestMessageDidChange:(NBMessage *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Properties

- (void)setConversations:(NSArray *)conversations
{
    self.data = conversations;
}

- (NSArray *)conversations
{
    return self.data;
}

#pragma mark - Other methods

- (NBConversation *)selectedConversation
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    return [self conversationAtIndexPath:selectedIndexPath];
}

- (NBConversation *)conversationAtIndexPath:(NSIndexPath *)indexPath
{
    return self.conversations[indexPath.row];
}

@end
