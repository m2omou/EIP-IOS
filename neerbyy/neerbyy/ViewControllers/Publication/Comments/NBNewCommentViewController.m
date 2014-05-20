//
//  NBNewCommentViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 20/05/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBNewCommentViewController.h"

@interface NBNewCommentViewController ()

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation NBNewCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self themeDescriptionTextView];
}

#pragma mark - Theming

- (void)themeDescriptionTextView
{
    self.descriptionTextView.tintColor = self.theme.lightGreenColor;
}

#pragma mark - User interactions

- (IBAction)tappedValidationButton:(id)sender
{
    [self validateForm];
}

- (IBAction)tappedCancelButton:(id)sender
{
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
