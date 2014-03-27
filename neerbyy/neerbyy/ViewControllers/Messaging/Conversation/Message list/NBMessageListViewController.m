//
//  NBMessageListViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBMessageListViewController.h"
#import "NBMessageTableViewCell.h"

#pragma mark - Constants

static NSString * const kNBMessageCellIdentifier = @"NBMessageTableViewCellIdentifier";

#pragma mark -


@interface NBMessageListViewController ()

@end

@implementation NBMessageListViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.messages = @[@1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1];
    
    self.reuseIdentifier = kNBMessageCellIdentifier;
    self.onConfigureCell = ^(NBMessageTableViewCell *cell, id associatedMessage, NSUInteger dataIdx)
    {
        [cell configureWithMessage:associatedMessage];
    };
}

#pragma mark - Properties

- (void)setMessages:(NSArray *)messages
{
    self.data = messages;
}

- (NSArray *)messagess
{
    return self.data;
}

@end
