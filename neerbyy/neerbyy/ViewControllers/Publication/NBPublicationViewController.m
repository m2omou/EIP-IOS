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

@interface NBPublicationViewController ()

@property (strong, nonatomic) NBCommentListViewController *commentsListViewController;
@property (strong, nonatomic) IBOutlet UIView *publicationContainerView;
@property (strong, nonatomic) IBOutlet NBPrimaryButton *upvoteButton;
@property (strong, nonatomic) IBOutlet NBPrimaryButton *downvoteButton;

@end


@implementation NBPublicationViewController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    NBPublication *publication = self.publication;
    NBVote *vote = publication.voteOfCurrentUser;
    
    [self addPublicationContentToContainerView];
    [self configureLikesAndDislikesWithVote:vote publication:publication];
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    static NSString * const kNBCommentsTableViewSegue = @"commentsTableViewSegue";
    static NSString * const kNBNewCommentsSegue = @"newCommentSegue";
    
    if ([segue.identifier isEqualToString:kNBCommentsTableViewSegue])
    {
        self.commentsListViewController = segue.destinationViewController;
        __weak NBPublicationViewController *weakSelf = self;
        self.commentsListViewController.onReload = ^(NBComment *firstComment) {
            [weakSelf reloadCommentsWithSinceComment:firstComment];
        };
        [self loadComments];
    }
    else if ([segue.identifier isEqualToString:kNBNewCommentsSegue])
    {
        NBNewCommentViewController *newCommentViewController = segue.destinationViewController;
        newCommentViewController.publication = self.publication;
    }
}


#pragma mark - User interactions

- (IBAction)pressedVoteButton:(id)sender
{
    NBVoteValue value;

    if (sender == self.upvoteButton)
        value = kNBVoteValueUpvote;
    else
        value = kNBVoteValueDownvote;
    
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

#pragma mark - Other methods

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

- (void)addPublicationContentToContainerView
{
    NBPublication *publication = self.publication;
    
    switch (publication.type) {
        case kNBPublicationTypeText:
            break;
            
        case kNBPublicationTypeImage:
            [self addImagePublicationContent];
            break;

        case kNBPublicationTypeLink:
            [self addLinkPublicationContent];
            break;

        case kNBPublicationTypeYoutube:
            break;

        case kNBPublicationTypeFile:
            break;

        case kNBPublicationTypeUnknown:
            [self addTextPublicationContent];
            break;
    }
}

- (void)addTextPublicationContent
{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.editable = NO;
    textView.text = textView.text = self.publication.contentDescription;
    
    [self addPublicationContentViewToContainerView:textView];
}

- (void)addImagePublicationContent
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setImageFromURL:self.publication.contentURL];

    [self addPublicationContentViewToContainerView:imageView];
}

- (void)addLinkPublicationContent
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:[NSURLRequest requestWithURL:self.publication.contentURL]];
    
    [self addPublicationContentViewToContainerView:webView];
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

- (void)loadComments
{
    NSNumber *publicationId = self.publication.identifier;
    NBAPINetworkOperation *commentsOperation = [NBAPIRequest fetchCommentsForPublication:publicationId];
    
    [commentsOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NBAPIResponseCommentList *response = (NBAPIResponseCommentList *)operation.APIResponse;

        self.commentsListViewController.comments = response.comments;
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];

    [commentsOperation enqueue];
}

- (void)reloadCommentsWithSinceComment:(NBComment *)comment
{
    if (comment == nil)
    {
        [self loadComments];
        return ;
    }

    NSNumber *publicationId = self.publication.identifier;
    NSNumber *commentId = comment.identifier;
    NBAPINetworkOperation *reloadCommentsOperation = [NBAPIRequest fetchCommentsForPublication:publicationId sinceId:commentId];
    
    [reloadCommentsOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NBAPIResponseCommentList *response = (NBAPIResponseCommentList *)operation.APIResponse;
        
        NSArray *oldComments = self.commentsListViewController.comments;
        NSArray *newComments = response.comments;
        NSArray *allComments = [newComments arrayByAddingObjectsFromArray:oldComments];
        self.commentsListViewController.comments = allComments;
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    
    [reloadCommentsOperation enqueue];
}

@end
