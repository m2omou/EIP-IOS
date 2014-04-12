//
//  NBMenuTableViewController.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 12/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

@class NBMenuTableViewController;


@protocol NBMenuTableViewControllerDelegate <NSObject>

- (void)menuTableViewController:(NBMenuTableViewController *)menuTableViewController didSelectViewControllerWithIdentifier:(NSString *)identifier;

@end


@interface NBMenuTableViewController : UITableViewController

@property (weak, nonatomic) id<NBMenuTableViewControllerDelegate> delegate;

@end
