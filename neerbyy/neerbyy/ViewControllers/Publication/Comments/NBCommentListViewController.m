//
//  NBCommentListViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBCommentListViewController.h"
#import "NBCommentTableViewCell.h"
#import "NBComment.h"

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

#pragma mark - UITableViewController

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBComment *comment = [self commentAtIndexPath:indexPath];
    CGFloat height = [NBCommentTableViewCell heightForComment:comment width:CGRectGetWidth(self.tableView.bounds)];
    return height;
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

@end
