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
    if (!self.scrollViewForMoreData)
        self.scrollViewForMoreData = self.tableView;
    self.scrollViewForMoreData.delegate = self;
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
    static CGFloat lastOffset = 0.f;
    
    if (scrollView != self.scrollViewForMoreData ||
        self.onMoreData == nil ||
        self.canFetchMoreData == NO)
        return ;
    
    CGFloat actualPosition = scrollView.contentOffset.y + CGRectGetHeight(scrollView.bounds);
    CGFloat contentHeight = scrollView.contentSize.height;
    
    if (actualPosition - lastOffset < 0)
        return ;

    if (actualPosition >= contentHeight) {
        self.canFetchMoreData = NO;
        self.onMoreData(self.data.lastObject);
    }
    
    lastOffset = actualPosition;
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

- (void)addDataAtTop:(id)data
{
    [self addDatasAtTop:@[data]];
}

- (void)addDatasAtTop:(NSArray *)datas
{
    if (!datas.count)
        return ;

    BOOL reloadBackup = self.shouldReloadOnNewData;
    self.shouldReloadOnNewData = NO;
    self.data = [datas arrayByAddingObjectsFromArray:self.data];
    self.shouldReloadOnNewData = reloadBackup;
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSUInteger i = 0; i < datas.count; ++i)
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)addDataAtBottom:(id)data
{
    [self addDatasAtBottom:@[data]];
}

- (void)addDatasAtBottom:(NSArray *)datas
{
    if (!datas.count)
        return ;
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSUInteger i = 0; i < datas.count; ++i)
        [indexPaths addObject:[NSIndexPath indexPathForRow:(i + self.data.count) inSection:0]];

    BOOL reloadBackup = self.shouldReloadOnNewData;
    self.shouldReloadOnNewData = NO;
    self.data = [self.data arrayByAddingObjectsFromArray:datas];
    self.shouldReloadOnNewData = reloadBackup;
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)removeData:(id)data
{
    NSInteger dataIdx = [self.data indexOfObject:data];
    if (dataIdx == NSNotFound)
        return ;
    
    BOOL reloadBackup = self.shouldReloadOnNewData;
    self.shouldReloadOnNewData = NO;
    NSMutableArray *copy = [self.data mutableCopy];
    [copy removeObjectAtIndex:dataIdx];
    self.data = [copy copy];
    self.shouldReloadOnNewData = reloadBackup;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:dataIdx inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
