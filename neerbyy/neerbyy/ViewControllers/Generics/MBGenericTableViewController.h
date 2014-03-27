//
//  NBGenericTableViewController.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 20/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBTableViewCell.h"


typedef void (^NBGenericTableViewControllerBlock)(id cell, id associatedData, NSUInteger dataIdx);
typedef NSString *(^NBGenericTableViewControllerFilterBlock)(id data);


@interface NBGenericTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSString *reuseIdentifier;

@property (strong, nonatomic) NBGenericTableViewControllerBlock onConfigureCell;
@property (strong, nonatomic) NBGenericTableViewControllerBlock onCellTap;

@property (strong, nonatomic) NSString *filterText;
@property (strong, nonatomic) NBGenericTableViewControllerFilterBlock objectToStringBlock;

@end
