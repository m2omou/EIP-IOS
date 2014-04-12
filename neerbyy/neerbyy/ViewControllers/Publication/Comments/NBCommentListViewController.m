//
//  NBCommentListViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBCommentListViewController.h"
#import "NBCommentTableViewCell.h"


#pragma mark - Constants

static NSString * const kNBCommentCellIdentifier = @"NBCommentTableViewCellIdentifier";

#pragma mark -


@interface NBCommentListViewController ()

@end


@implementation NBCommentListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.comments = @[@1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1];
    
    self.reuseIdentifier = kNBCommentCellIdentifier;
    self.onConfigureCell = ^(NBCommentTableViewCell *cell, id associatedComment, NSUInteger dataIdx)
    {
        [cell configureWithComment:associatedComment];
    };
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

@end
