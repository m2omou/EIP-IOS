//
//  NBGenericTableViewController.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 20/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "MBGenericTableViewController.h"
#import "NBTheme.h"


@interface NBGenericTableViewController ()

@property (strong, nonatomic) NSArray *originalData;
@property (strong, nonatomic) NSArray *filteredData;
@property (assign, nonatomic) BOOL canReload;
@property (assign, nonatomic) BOOL canFetchMoreData;

@end


@implementation NBGenericTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.canReload = YES;
    self.canFetchMoreData = YES;
    self.shouldReloadOnNewData = YES;
    [self initRefreshControl];

    self.tableView.backgroundColor = [NBTheme sharedTheme].whiteColor;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    
    if (self.onConfigureCell)
    {
        id associatedData = [self dataAtIndexPath:indexPath];
        self.onConfigureCell(cell, associatedData, indexPath.row);
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onCellTap)
    {
        id cell = [tableView cellForRowAtIndexPath:indexPath];
        id associatedData = [self dataAtIndexPath:indexPath];
        self.onCellTap(cell, associatedData, indexPath.row);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;

    if (self.onMoreData && self.canFetchMoreData && actualPosition >= contentHeight) {
        self.canFetchMoreData = NO;
        self.onMoreData(self.data.lastObject);
    }
}

#pragma mark - Public methods

- (void)setFilterText:(NSString *)filterText
{
    NSAssert(self.objectToStringBlock, @"Filter text needs the objectToStringBlock property");

    if (filterText.length == 0)
    {
        self.filteredData = nil;
        self.data = self.originalData;
    }
    else
    {
        NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:^BOOL(id data, NSDictionary *bindings) {
            NSString *objectString = self.objectToStringBlock(data);
            NSRange rangeOfFilterString = [objectString rangeOfString:filterText options:NSCaseInsensitiveSearch];
            NSUInteger locationOfFilterString = rangeOfFilterString.location;
            return (locationOfFilterString != NSNotFound);
        }];
                
        self.filteredData = [self.originalData filteredArrayUsingPredicate:filterPredicate];
        self.data = self.filteredData;
    }
    
    [self.tableView reloadData];
}

- (void)endReload
{
    self.canReload = YES;
    [self.refreshControl endRefreshing];
}

- (void)endMoreData
{
    self.canFetchMoreData = YES;
}

#pragma mark - Properties

- (void)setData:(NSArray *)data
{
    if (_data == nil)
        self.originalData = data;

    _data = data;
    
    if (self.reloadsOnNewData)
        [self.tableView reloadData];
}

#pragma mark - Convenience methods

- (id)dataAtIndexPath:(NSIndexPath *)indexPath
{
    return self.data[indexPath.row];
}

#pragma mark - Convenience methods - Refresh control

- (void)initRefreshControl
{
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(triggeredRefreshControl) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
}

- (void)triggeredRefreshControl
{
    if (self.onReload && self.canReload)
    {
        self.canReload = NO;
        self.onReload(self.data.firstObject);
    }
}

@end
