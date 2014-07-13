//
//  NBPlaceListViewController.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "MBGenericTableViewController.h"

@class NBPlace;
@class NBPlaceListViewController;

@protocol NBPlaceListViewControllerDelegate <NSObject>

- (void)placeListViewController:(NBPlaceListViewController *)placeListViewController didPickPlace:(NBPlace *)place;

@end

@interface NBPlaceListViewController : NBGenericTableViewController

@property (strong, nonatomic) NSArray *places;
@property (weak, nonatomic) id<NBPlaceListViewControllerDelegate> delegate;

@end
