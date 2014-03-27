//
//  NBPlaceListViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPlaceListViewController.h"
#import "NBPlaceTableViewCell.h"

#pragma mark - Constants

static NSString * const kNBPlaceCellIdentifier = @"NBPlaceTableViewCellIdentifier";

#pragma mark -


@interface NBPlaceListViewController ()

@end

@implementation NBPlaceListViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.places = @[@1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1];
    
    self.reuseIdentifier = kNBPlaceCellIdentifier;
    self.onConfigureCell = ^(NBPlaceTableViewCell *cell, id associatedPlace, NSUInteger dataIdx)
    {
        [cell configureWithPlace:associatedPlace];
    };
}

#pragma mark - Properties

- (void)setPlaces:(NSArray *)places
{
    self.data = places;
}

- (NSArray *)places
{
    return self.data;
}

@end
