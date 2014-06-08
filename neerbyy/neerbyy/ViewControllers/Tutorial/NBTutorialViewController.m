//
//  NBTutorialViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 08/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBTutorialViewController.h"
#import "NBTutorialDataSource.h"
#import "NBTutorialCell.h"

static NSString * const kNBTutorialCell = @"tutorialCell";
static CGFloat const kNBTutorialParallaxRatio = 1.3f;

@interface NBTutorialViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NBTutorialDataSource *dataSource;
@property (strong, nonatomic) IBOutlet NBPrimaryButton *continueButton;
@property (strong, nonatomic) IBOutlet UIButton *previousPageButton;
@property (strong, nonatomic) IBOutlet UIButton *nextPageButton;

@end

@implementation NBTutorialViewController

#pragma mark - View life cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.dataSource = [NBTutorialDataSource new];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackground];
    [self showContinueButtonIfNeeded];
}

#pragma mark - Initialisations

- (void)addBackground
{
    UIImageView *imageView = [self addBackgroundImageView];
    [self addDimmingViewToImageView:imageView];
    [self.backgroundScrollView layoutIfNeeded];
}

- (UIImageView *)addBackgroundImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tuto_background"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundScrollView addSubview:imageView];
    
    CGFloat const backgroundBouncePadding = 250.f;
    CGFloat backgroundWidth = CGRectGetWidth(self.backgroundScrollView.bounds) * self.dataSource.numberOfPages;
    CGFloat backgroundHeight = CGRectGetHeight(self.backgroundScrollView.bounds);
    NSDictionary *metrics = @{@"backgroundWidth":@((backgroundWidth + backgroundBouncePadding) * kNBTutorialParallaxRatio),
                              @"backgroundHeight":@(backgroundHeight),
                              @"backgroundLeftPadding":@(-backgroundBouncePadding)};
    NSDictionary *views = NSDictionaryOfVariableBindings(imageView);
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-backgroundLeftPadding-[imageView(backgroundWidth)]|"
                                                                    options:0 metrics:metrics views:views];
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(backgroundHeight)]|" options:0 metrics:metrics views:views];
    NSArray *constaints = [hConstraints arrayByAddingObjectsFromArray:vConstraints];
    [self.backgroundScrollView addConstraints:constaints];

    return imageView;
}

- (void)addDimmingViewToImageView:(UIImageView *)imageView
{
    UIView *dimView = [UIView new];
    dimView.translatesAutoresizingMaskIntoConstraints = NO;
    dimView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    [imageView addSubview:dimView];

    NSDictionary *views = NSDictionaryOfVariableBindings(dimView);
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dimView]|" options:0 metrics:nil views:views];
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[dimView]|" options:0 metrics:nil views:views];
    NSArray *dimConstaints = [hConstraints arrayByAddingObjectsFromArray:vConstraints];
    [imageView addConstraints:dimConstaints];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView)
    {
        [self applyParallaxEffectToBackgroundView];
        [self showContinueButtonIfNeeded];
    }
}

#pragma mark - UICollectionViewDataSource - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.collectionView.bounds.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.numberOfPages;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NBTutorialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNBTutorialCell forIndexPath:indexPath];
    NBTutorialContent *content = [self.dataSource contentForPage:indexPath.row];

    [cell configureWithContent:content];

    return cell;
}

#pragma mark - User interactions

- (IBAction)pressedContinueButton:(id)sender
{
    [self dismiss];
}

- (IBAction)pressedPreviousPageButton:(id)sender
{
    NSInteger collectionViewPage = [self currentPageNumber];
    if (collectionViewPage == 0)
        return ;
    
    [self moveToPage:collectionViewPage - 1];
}

- (IBAction)pressedNextPageButton:(id)sender
{
    NSInteger collectionViewPage = [self currentPageNumber];
    if (collectionViewPage >= self.dataSource.numberOfPages)
        return ;
    
    [self moveToPage:collectionViewPage + 1];
}

#pragma mark - Convenience methods

- (void)applyParallaxEffectToBackgroundView
{
    CGFloat expectedXOffset = self.collectionView.contentOffset.x;
    CGFloat adjustedXOffset = expectedXOffset * kNBTutorialParallaxRatio;
    
    CGPoint contentOffset = self.backgroundScrollView.contentOffset;
    contentOffset.x = adjustedXOffset;
    self.backgroundScrollView.contentOffset = contentOffset;
}

- (void)showContinueButtonIfNeeded
{
    NSUInteger collectionViewPage = [self currentPageNumber];
    NSUInteger numberOfPages = self.dataSource.numberOfPages;
    BOOL isFirstPage = collectionViewPage == 0;
    BOOL isLastPage = collectionViewPage >= numberOfPages - 1;
    
    [UIView animateWithDuration:.3f animations:^{
        self.previousPageButton.alpha = (isFirstPage == NO && isLastPage == NO);
        self.nextPageButton.alpha = (isLastPage == NO);
        self.continueButton.alpha = (isLastPage == YES);
    }];
}

- (NSInteger)currentPageNumber
{
    CGFloat collectionViewXOffset = self.collectionView.contentOffset.x;
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds);
    
    NSUInteger collectionViewPage = collectionViewXOffset / collectionViewWidth;
    return collectionViewPage;
}

- (void)moveToPage:(NSInteger)page
{
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds);
    CGFloat collectionViewXOffset = page * collectionViewWidth;
    
    CGPoint contentOffset = self.collectionView.contentOffset;
    contentOffset.x = collectionViewXOffset;
    [self.collectionView setContentOffset:contentOffset animated:YES];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
