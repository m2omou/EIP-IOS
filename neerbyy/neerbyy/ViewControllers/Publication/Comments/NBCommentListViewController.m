//
//  NBCommentListViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBCommentListViewController.h"
#import "NBCommentTableViewCell.h"
#import "NBPersistanceManager.h"
#import "NBComment.h"
#import "NBAPI.h"

#pragma mark - Constants

static NSString * const kNBCommentCellIdentifier = @"NBCommentTableViewCellIdentifier";

#pragma mark -


@interface NBCommentListViewController ()

@end


@implementation NBCommentListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reuseIdentifier = kNBCommentCellIdentifier;
    self.onConfigureCell = ^(NBCommentTableViewCell *cell, NBComment *associatedComment, NSUInteger dataIdx)
    {
        [cell configureWithComment:associatedComment];
    };
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBComment *comment = [self commentAtIndexPath:indexPath];
    CGFloat height = [NBCommentTableViewCell heightForComment:comment width:CGRectGetWidth(self.tableView.bounds)];
    return height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBPersistanceManager *persistanceManager = [NBPersistanceManager sharedManager];
    if (persistanceManager.isConnected == NO)
        return NO;
    
    NBComment *comment = [self commentAtIndexPath:indexPath];
    NBUser *currentUser = persistanceManager.currentUser;
    BOOL isFromCurrentUser = [comment isFromUser:currentUser];
    return isFromCurrentUser;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
        [self removeCommentAtIndexPath:indexPath];
}

#pragma mark - Properties

- (void)setComments:(NSArray *)comments
{
    self.data = comments;
}

- (NSArray *)comments
{
    return self.data;
}

- (NBComment *)commentAtIndexPath:(NSIndexPath *)indexPath
{
    return self.comments[indexPath.row];
}

#pragma mark - Convenience methods

- (void)removeCommentAtIndexPath:(NSIndexPath *)indexPath
{
    NBComment *comment = [self commentAtIndexPath:indexPath];
    NBAPINetworkOperation *deleteOperation = [NBAPIRequest removeComment:comment.identifier];
    
    [deleteOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        [self removeData:comment];
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    [deleteOperation enqueue];
}

@end
