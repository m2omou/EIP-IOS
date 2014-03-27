//
//  NBPlaceViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPlaceViewController.h"
#import "NBPlace.h"

@interface NBPlaceViewController ()

@end


@implementation NBPlaceViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.place.name;
}

#pragma mark - User interactions

- (IBAction)pressedAddToFavoritesButton:(id)sender
{
}

@end
