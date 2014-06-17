//
//  NBConversationListViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBConversationListViewController.h"
#import "NBConversationTableViewCell.h"


#pragma mark - Constants

static NSString * const kNBConversationCellIdentifier = @"NBConversationTableViewCellIdentifier";

#pragma mark -


@interface NBConversationListViewController ()

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

#pragma mark - Properties

- (void)setConversations:(NSArray *)conversations
{
    self.data = conversations;
}

- (NSArray *)conversations
{
    return self.data;
}

@end
