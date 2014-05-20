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
typedef void (^NBGenericTableViewControllerReloadBlock)(id firstData);

@interface NBGenericTableViewController : UITableViewController

@property (assign, nonatomic, getter = reloadsOnNewData) BOOL shouldReloadOnNewData;

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSString *reuseIdentifier;

@property (strong, nonatomic) NBGenericTableViewControllerBlock onConfigureCell;
@property (strong, nonatomic) NBGenericTableViewControllerBlock onCellTap;

@property (strong, nonatomic) NSString *filterText;
@property (strong, nonatomic) NBGenericTableViewControllerFilterBlock objectToStringBlock;

@property (strong, nonatomic) NBGenericTableViewControllerReloadBlock onReload;
@property (strong, nonatomic) NBGenericTableViewControllerReloadBlock onMoreData;

@end
