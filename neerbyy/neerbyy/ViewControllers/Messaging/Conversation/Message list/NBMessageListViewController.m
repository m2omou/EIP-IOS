//
//  NBMessageListViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBMessageListViewController.h"
#import "NBMessageTableViewCell.h"
#import "NBMessage.h"

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
    
    self.reuseIdentifier = kNBMessageCellIdentifier;
    self.onConfigureCell = ^(NBMessageTableViewCell *cell, NBMessage *associatedMessage, NSUInteger dataIdx)
    {
        [cell configureWithMessage:associatedMessage];
    };
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBMessage *message = [self messageAtIndexPath:indexPath];
    CGFloat height = [NBMessageTableViewCell heightForMessage:message width:CGRectGetWidth(self.tableView.bounds)];
    return height;
}

#pragma mark - Properties

- (void)setMessages:(NSArray *)messages
{
    self.data = messages;
}

- (NSArray *)messages
{
    return self.data;
}

- (NBMessage *)messageAtIndexPath:(NSIndexPath *)indexPath
{
    return self.messages[indexPath.row];
}

@end
