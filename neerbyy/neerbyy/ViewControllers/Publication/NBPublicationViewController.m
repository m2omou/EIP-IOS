//
//  NBPublicationViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPublicationViewController.h"
#import "NBCommentListViewController.h"
#import "NBNewCommentViewController.h"
#import "NBComment.h"
#import "NBPublication.h"
#import <JTSImageViewController.h>
#import <JTSImageInfo.h>
#import <TOWebViewController.h>
#import "NBAppDelegate.h"
#import "NBCircleImageView.h"
#import "NBReportViewController.h"
#import "NBUser.h"
#import "NBUserViewController.h"
#import "UIStoryboard+NBAdditions.h"

static NSString * const kNBNewCommentsSegue = @"newCommentSegue";

@interface NBPublicationViewController () <NBNewCommentViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NBCommentListViewController *commentsListViewController;
@property (strong, nonatomic) IBOutlet UIView *publicationContainerView;
@property (strong, nonatomic) IBOutlet NBPrimaryButton *upvoteButton;
@property (strong, nonatomic) IBOutlet NBPrimaryButton *downvoteButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentsHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *voteView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewsTopSpaceConstraint;

@end


@implementation NBPublicationViewController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    NBPublication *publication = self.publication;
    NBVote *vote = publication.voteOfCurrentUser;
    
    [self addPublicationContentToContainerView];
    [self configureUserButtonItem];
    [self configureLikesAndDislikesWithVote:vote publication:publication];
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString * const kNBCommentsTableViewSegue = @"commentsTableViewSegue";
    static NSString * const kNBReportPublicationSegue = @"reportPublicationSegue";
    
    if ([segue.identifier isEqualToString:kNBCommentsTableViewSegue])
    {
        self.commentsListViewController = segue.destinationViewController;
        [self configureCommentsViewController];
    }
    else if ([segue.identifier isEqualToString:kNBNewCommentsSegue])
    {
        NBNewCommentViewController *newCommentViewController = segue.destinationViewController;
        newCommentViewController.publication = self.publication;
        newCommentViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:kNBReportPublicationSegue])
    {
        NBReportViewController *reportViewController = segue.destinationViewController;
        reportViewController.identifierToReport = self.publication.identifier;
        reportViewController.operationCreator = @selector(reportPublication:withDescription:);
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:kNBNewCommentsSegue])
    {
        if (self.persistanceManager.isConnected)
            return YES;
        else
        {
            NBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate showLoginAlertViewWithViewController:self completion:^{
                if (self.persistanceManager.isConnected)
                    [self performSegueWithIdentifier:identifier sender:sender];
            }];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - NBNewCommentViewControllerDelegate

- (void)newCommentViewController:(NBNewCommentViewController *)newCommentViewController didPublishComment:(NBComment *)comment
{
    [self.commentsListViewController addDataAtTop:comment];
    [self updateCommentsHeight];
}

#pragma mark - User interactions

- (IBAction)pressedVoteButton:(id)sender
{
    NBVoteValue value;

    if (sender == self.upvoteButton)
        value = kNBVoteValueUpvote;
    else
        value = kNBVoteValueDownvote;
    
    if (self.persistanceManager.isConnected)
        [self performVoteWithValue:value];
    else
    {
        NBAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate showLoginAlertViewWithViewController:self completion:^{
            if (self.persistanceManager.isConnected)
                [self performVoteWithValue:value];
        }];
    }
}

- (IBAction)pressedPublicationContainerView:(id)sender
{
    [self pushPublicationContentViewController];
}

- (void)pressedUserButton:(UIBarButtonItem *)button
{
    [self pushUserViewController];
}

#pragma mark - Convenience methods - Votes

- (void)performVoteWithValue:(NBVoteValue)value
{
    if ([self userIsCancellingVote:value])
        [self cancelVote];
    else
        [self voteWithValue:value];
}

- (BOOL)userIsCancellingVote:(NBVoteValue)value
{
    NBVote *vote = self.publication.voteOfCurrentUser;
    if (vote == nil)
        return NO;
    
    NBVoteValue currentVoteValue = vote.value;
    if (currentVoteValue == value)
        return YES;
    else
        return NO;
}

- (void)cancelVote
{
    NSNumber *voteIdentifier = self.publication.voteOfCurrentUser.identifier;
    NBAPINetworkOperation *cancelVoteOperation = [NBAPIRequest cancelVote:voteIdentifier];
    
    [cancelVoteOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NBAPIResponseVote *response = (NBAPIResponseVote *)operation.APIResponse;
        
        self.publication.numberOfUpvotes = response.publication.numberOfUpvotes;
        self.publication.numberOfDownvotes = response.publication.numberOfDownvotes;
        self.publication.voteOfCurrentUser = nil;
        [self configureLikesAndDislikesWithVote:nil publication:response.publication];
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    
    [cancelVoteOperation enqueue];
}

- (void)voteWithValue:(NBVoteValue)value
{
    NSNumber *publicationId = self.publication.identifier;
    NBAPINetworkOperation *voteOperation = [NBAPIRequest voteOnPublication:publicationId withValue:value];
    
    [voteOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NBAPIResponseVote *response = (NBAPIResponseVote *)operation.APIResponse;
        
        self.publication.numberOfUpvotes = response.publication.numberOfUpvotes;
        self.publication.numberOfDownvotes = response.publication.numberOfDownvotes;
        self.publication.voteOfCurrentUser = response.vote;
        [self configureLikesAndDislikesWithVote:response.vote publication:response.publication];
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    
    [voteOperation enqueue];
}

- (void)configureLikesAndDislikesWithVote:(NBVote *)vote publication:(NBPublication *)publication
{
    [self restoreVoteButtons];
    if (vote != nil)
        [self configureVoteButtonsForVote:vote];
    if (publication != nil)
        [self configureLikesAndDislikesWithLikes:publication.numberOfUpvotes dislikes:publication.numberOfDownvotes];
}

- (void)restoreVoteButtons
{
    self.upvoteButton.layer.borderWidth = self.downvoteButton.layer.borderWidth = 0.f;
    self.upvoteButton.layer.borderColor = self.downvoteButton.layer.borderColor = [UIColor clearColor].CGColor;
}

- (void)configureVoteButtonsForVote:(NBVote *)vote
{
    NBPrimaryButton *votedButton;
    
    if (vote.value == kNBVoteValueUpvote)
        votedButton = self.upvoteButton;
    else
        votedButton = self.downvoteButton;
    
    votedButton.layer.borderColor = self.theme.orangeColor.CGColor;
    votedButton.layer.borderWidth = 1.f;
}

- (void)configureLikesAndDislikesWithLikes:(NSNumber *)numberOfLikes dislikes:(NSNumber *)numberOfDislikes
{
    [self.upvoteButton setTitle:numberOfLikes.stringValue forState:UIControlStateNormal];
    [self.downvoteButton setTitle:numberOfDislikes.stringValue forState:UIControlStateNormal];
}

#pragma mark - Convenience methods - Publication details

- (void)pushPublicationContentViewController {
    NBPublication *publication = self.publication;
    
    switch (publication.type) {
        case kNBPublicationTypeImage:
            [self showImageViewController];
            break;
        
        case kNBPublicationTypeLink:
        case kNBPublicationTypeYoutube:
            [self pushWebViewController];
            break;
            
        case kNBPublicationTypeUnknown:
            if (publication.contentURL)
                [self pushWebViewController];
            break;

        case kNBPublicationTypeFile:
        case kNBPublicationTypeText:
            break;
    }
}

- (void)showImageViewController
{
    UIImageView *imageView = self.publicationContainerView.subviews.firstObject;
    if ([imageView isKindOfClass:[UIImageView class]] == NO)
        return ;

    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = imageView.image;
    imageInfo.referenceRect = imageView.frame;
    imageInfo.referenceView = self.view;
    
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundStyle_ScaledDimmedBlurred];
    
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
    
}

- (void)pushWebViewController
{
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:self.publication.contentURL];

    [self.navigationController pushViewController:webViewController animated:YES];
    
    if ([webViewController respondsToSelector:@selector(toolbar)]) {
        UIToolbar *toolbar = [webViewController performSelector:@selector(toolbar) withObject:nil];
        if ([toolbar respondsToSelector:@selector(tintColor)])
            toolbar.tintColor = self.theme.lightGreenColor;
    }
}

- (void)configureUserButtonItem
{
    UIImageView *imageView = [[NBCircleImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    imageView.layer.borderColor = self.theme.whiteColor.CGColor;
    imageView.layer.borderWidth = 1.f;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"img-avatar"];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedUserButton:)]];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    [[NBAPINetworkEngine engine] imageAtURL:self.publication.author.avatarThumbnailURL completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        imageView.image = fetchedImage;
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error){}];
}

- (void)addPublicationContentToContainerView
{
    NBPublication *publication = self.publication;
    
    switch (publication.type) {
        case kNBPublicationTypeFile:
        case kNBPublicationTypeText:
            [self addTextPublicationContent];
            break;

        case kNBPublicationTypeYoutube:
        case kNBPublicationTypeLink:
            [self addWebPublicationContent];
            break;
            
        case kNBPublicationTypeUnknown:
            if (publication.contentURL)
                [self addWebPublicationContent];
            else
                [self addTextPublicationContent];
            break;
            
        case kNBPublicationTypeImage:
            [self addImagePublicationContent];
            break;
    }
}

- (void)addWebPublicationContent
{
    [self addTextPublicatioonContentWithIcon:[UIImage imageNamed:@"img-web"]];
}

- (void)addTextPublicationContent
{
    [self addTextPublicatioonContentWithIcon:nil];
}

- (void)addTextPublicatioonContentWithIcon:(UIImage *)icon
{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.font = [self.theme.font fontWithSize:13.f];
    textView.backgroundColor = self.theme.lightGreenColor;
    textView.textColor = self.theme.whiteColor;
    textView.editable = NO;
    textView.showsHorizontalScrollIndicator = textView.alwaysBounceHorizontal = NO;
    textView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.text = textView.text = self.publication.contentDescription;
    
    [self addPublicationContentViewToContainerView:textView];
    [self setPublicationHeight:40];

    if (icon) {
        UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
        iconView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.publicationContainerView addSubview:iconView];
        NSDictionary *views = NSDictionaryOfVariableBindings(iconView);
        NSArray *hConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[iconView(20)]-5-|" options:0 metrics:0 views:views];
        NSArray *vConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[iconView(20)]" options:0 metrics:0 views:views];
        NSArray *constraints = [hConstraint arrayByAddingObjectsFromArray:vConstraint];
        [self.publicationContainerView addConstraints:constraints];
        [self.publicationContainerView layoutIfNeeded];
    }
    
}

- (void)addImagePublicationContent
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.backgroundColor = self.theme.lightGreenColor;
    imageView.userInteractionEnabled = YES;
    [imageView setImageFromURL:self.publication.contentURL];

    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.font = [self.theme.font fontWithSize:9.f];
    textView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7f];
    textView.textColor = self.theme.whiteColor;
    textView.editable = NO;
    textView.showsHorizontalScrollIndicator = textView.alwaysBounceHorizontal = NO;
    textView.text = textView.text = self.publication.contentDescription;

    [self addView:textView asCaptionOfView:imageView withHeight:30];
    [self addPublicationContentViewToContainerView:imageView];
    [self setPublicationHeight:100];
}

- (void)addPublicationContentViewToContainerView:(UIView *)contentView
{
    contentView.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *superView = self.publicationContainerView;
    [superView addSubview:contentView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|"
                                                                    options:0 metrics:0
                                                                      views:views];
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|"
                                                                    options:0 metrics:0
                                                                      views:views];
    NSArray *constraints = [hConstraints arrayByAddingObjectsFromArray:vConstraints];
    [superView addConstraints:constraints];
}

- (void)addView:(UITextView *)contentView asCaptionOfView:(UIView *)superView withHeight:(CGFloat)height
{
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:contentView];

    NSDictionary *metrics = @{@"height":@(height)};
    NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|"
                                                                    options:0 metrics:0
                                                                      views:views];
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView(height)]|"
                                                                    options:0 metrics:metrics
                                                                      views:views];
    NSArray *constraints = [hConstraints arrayByAddingObjectsFromArray:vConstraints];
    [superView addConstraints:constraints];
}

- (void)setPublicationHeight:(CGFloat)height
{
    self.viewsTopSpaceConstraint.constant = height;
    [self.view layoutIfNeeded];
}

#pragma mark - Convenience methods - Comments

- (void)loadComments
{
    NSNumber *publicationId = self.publication.identifier;
    NBAPINetworkOperation *commentsOperation = [NBAPIRequest fetchCommentsForPublication:publicationId];
    
    [commentsOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NBAPIResponseCommentList *response = (NBAPIResponseCommentList *)operation.APIResponse;

        self.commentsListViewController.comments = response.comments;
        [self updateCommentsHeight];
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];

    [commentsOperation enqueue];
}

- (void)loadCommentsAfterComment:(NBComment *)comment
{
    if (comment == nil)
    {
        [self.commentsListViewController endMoreData];
        return ;
    }
    
    NBAPINetworkOperation *loadMoreCommentsOperation = [NBAPIRequest fetchCommentsForPublication:self.publication.identifier afterId:comment.identifier];
    
    [loadMoreCommentsOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponseCommentList *response = (NBAPIResponseCommentList *)completedOperation.APIResponse;
        
        NSArray *newComments = response.comments;
        if (!newComments.count)
            return ;
        [self.commentsListViewController addDatasAtBottom:newComments];
        [self updateCommentsHeight];
        [self.commentsListViewController endMoreData];
    } errorHandler:^(NBAPINetworkOperation *failedOp, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](failedOp, error);
        [self.commentsListViewController endMoreData];
    }];
    
    [loadMoreCommentsOperation enqueue];
}

- (void)updateCommentsHeight
{
    CGFloat commentsHeight = self.commentsListViewController.tableView.contentSize.height;
    CGFloat minimalCommentHeight = [self minimalHeightForComments];
    commentsHeight = MAX(minimalCommentHeight, commentsHeight);
    
    self.commentsHeightConstraint.constant = commentsHeight;
    [self.view layoutIfNeeded];
}

- (CGFloat)minimalHeightForComments
{
    return CGRectGetHeight(self.scrollView.bounds) - (self.voteView.frame.origin.y + CGRectGetHeight(self.voteView.bounds) + self.topLayoutGuide.length);
}

- (void)configureCommentsViewController
{
    self.commentsListViewController.scrollViewForMoreData = self.scrollView;
    __weak NBPublicationViewController *weakSelf = self;
    self.commentsListViewController.onMoreData = ^(NBComment *lastComment) {
        [weakSelf loadCommentsAfterComment:lastComment];
    };
    [self loadComments];
}

- (void)pushUserViewController
{
    NBUserViewController *userViewController = [UIStoryboard userViewController];
    userViewController.user = self.publication.author;
    [self.navigationController pushViewController:userViewController animated:YES];
}

@end
