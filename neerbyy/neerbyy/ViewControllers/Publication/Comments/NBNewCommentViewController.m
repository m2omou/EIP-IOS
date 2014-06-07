//
//  NBNewCommentViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 20/05/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBNewCommentViewController.h"
#import "NBLabel.h"

@interface NBNewCommentViewController ()

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet NBLabel *placeHolderLabel;

@end

@implementation NBNewCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self themeDescriptionTextView];
    __weak NBNewCommentViewController *weakSelf = self;
    self.customValidation = ^BOOL{
        if (weakSelf.descriptionTextView.text.length == 0)
            return NO;
        return YES;
    };
}

#pragma mark - Theming

- (void)themeDescriptionTextView
{
    UIColor *textColor = self.theme.lightGreenColor;

    self.placeHolderLabel.textColor = textColor;
    self.descriptionTextView.tintColor = textColor;
}

#pragma mark - User interactions

- (IBAction)tappedValidationButton:(id)sender
{
    [self validateForm];
}

- (IBAction)tappedCancelButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(newCommentViewControllerDidDismiss:)])
        [self.delegate newCommentViewControllerDidDismiss:self];
    [self dismiss];
}

#pragma mark - NBGenericFormViewController

- (void)validateForm
{
    [super validateForm];
    [self disableValidationButton];
    [self createComment];
}

#pragma mark - UIBarPositioningDelegate

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView;
{
    BOOL hidePlaceHolder = (self.descriptionTextView.text.length > 0);
    self.placeHolderLabel.hidden = hidePlaceHolder;
    
    [self enableValidationButtonIfNeeded];
}

#pragma mark - Convinience methods

- (void)createComment
{
    NSString *description = self.descriptionTextView.text;
    NSNumber *publicationIdentifier = self.publication.identifier;

    [self createCommentWithPublicationIdentifier:publicationIdentifier description:description];
    
}

- (void)createCommentWithPublicationIdentifier:(NSNumber *)publicationIdentifier description:(NSString *)description
{
    NBAPINetworkOperation *publishOperation = [NBAPIRequest commentOnPublication:publicationIdentifier withMessage:description];
    
    [publishOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NBAPIResponseComment *response = (NBAPIResponseComment *)operation.APIResponse;
        if ([self.delegate respondsToSelector:@selector(newCommentViewController:didPublishComment:)])
            [self.delegate newCommentViewController:self didPublishComment:response.comment];
        [self dismiss];
    } errorHandler:^(NBAPINetworkOperation *operation, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](operation, error);
        [self enableValidationButtonIfNeeded];
    }];
    
    [publishOperation enqueue];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
