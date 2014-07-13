//
//  NBPlaceListViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPlaceListViewController.h"
#import "NBPlaceTableViewCell.h"
#import "NBPlaceViewController.h"

#pragma mark - Constants

static NSString * const kNBPlaceSegue = @"placeSegue";
static NSString * const kNBPlaceCellIdentifier = @"NBPlaceTableViewCellIdentifier";

#pragma mark -


@interface NBPlaceListViewController ()

@end


@implementation NBPlaceListViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reuseIdentifier = kNBPlaceCellIdentifier;
    self.onConfigureCell = ^(NBPlaceTableViewCell *cell, id associatedPlace, NSUInteger dataIdx)
    {
        [cell configureWithPlace:associatedPlace];
    };
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kNBPlaceSegue])
    {
        NBPlaceViewController *placeViewController = segue.destinationViewController;
        placeViewController.place = [self selectedPlace];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:kNBPlaceSegue])
    {
        if (self.delegate == nil)
            return YES;
        return NO;
    }
    return YES;
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

- (NBPlace *)placeAtIndexPath:(NSIndexPath *)indexPath
{
    return self.places[indexPath.row];
}

- (NBPlace *)selectedPlace
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    return [self placeAtIndexPath:selectedIndexPath];
}

@end
