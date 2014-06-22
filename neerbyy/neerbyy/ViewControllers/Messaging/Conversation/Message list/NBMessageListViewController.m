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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scrollToBottomAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBMessage *message = [self messageAtIndexPath:indexPath];
    CGFloat height = [NBMessageTableViewCell heightForMessage:message width:CGRectGetWidth(self.tableView.bounds)];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
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

#pragma mark - Convenience methods

- (void)scrollToBottomAnimated:(BOOL)animated
{
    UITableView *tableView = self.tableView;
    CGRect bounds = tableView.bounds;
    CGSize contentSize = tableView.contentSize;
    
    [tableView scrollRectToVisible:CGRectMake(0, contentSize.height - CGRectGetHeight(bounds),
                                              CGRectGetWidth(bounds), CGRectGetHeight(bounds))
                          animated:animated];
}

@end
