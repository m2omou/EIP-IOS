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
typedef void (^NBGenericTableViewControllerFetchDataBlock)(id firstOrLastData);

@interface NBGenericTableViewController : UITableViewController

@property (assign, nonatomic, getter = reloadsOnNewData) BOOL shouldReloadOnNewData;

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSString *reuseIdentifier;

@property (strong, nonatomic) NBGenericTableViewControllerBlock onConfigureCell;
@property (strong, nonatomic) NBGenericTableViewControllerBlock onCellTap;

@property (strong, nonatomic) NSString *filterText;
@property (strong, nonatomic) NBGenericTableViewControllerFilterBlock objectToStringBlock;

@property (strong, nonatomic) NBGenericTableViewControllerFetchDataBlock onReload;
- (void)endReload;

@property (weak, nonatomic) UIScrollView *scrollViewForMoreData;
@property (strong, nonatomic) NBGenericTableViewControllerFetchDataBlock onMoreData;
- (void)endMoreData;

- (void)addDataAtTop:(id)data;
- (void)addDatasAtTop:(NSArray *)datas;
- (void)addDataAtBottom:(id)data;
- (void)addDatasAtBottom:(NSArray *)datas;
- (void)removeData:(id)data;

@end
