//
//  NBPublicationListViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPublicationListViewController.h"
#import "NBPublicationTableViewCell.h"


#pragma mark - Constants

static NSString * const kNBPublicationCellIdentifier = @"NBPublicationTableViewCellIdentifier";

#pragma mark -


@interface NBPublicationListViewController ()

@end


@implementation NBPublicationListViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reuseIdentifier = kNBPublicationCellIdentifier;
    self.onConfigureCell = ^(NBPublicationTableViewCell *cell, NBPublication *associatedPublication, NSUInteger dataIdx)
    {
        [cell configureWithPublication:associatedPublication];
    };
}

#pragma mark - Properties

- (void)setPublications:(NSArray *)publications
{
    self.data = publications;
}

- (NSArray *)publications
{
    return self.data;
}

@end
