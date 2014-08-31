//
//  NBNewMessageViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBNewMessageViewController.h"
#import "NBLabel.h"
#import <GAI.h>
#import <GAIFields.h>
#import <GAIDictionaryBuilder.h>


@interface NBNewMessageViewController ()

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet NBLabel *placeHolderLabel;

@end


@implementation NBNewMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self themeDescriptionTextView];
    __weak NBNewMessageViewController *weakSelf = self;
    self.customValidation = ^BOOL{
        if (weakSelf.descriptionTextView.text.length == 0)
            return NO;
        return YES;
    };
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.descriptionTextView becomeFirstResponder];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"New message"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
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
    if ([self.delegate respondsToSelector:@selector(newMessageViewControllerDidDismiss:)])
        [self.delegate newMessageViewControllerDidDismiss:self];
    [self dismiss];
}

#pragma mark - NBGenericFormViewController

- (void)validateForm
{
    [super validateForm];
    [self disableValidationButton];
    [self createMessage];
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

- (void)createMessage
{
    NSString *content = self.descriptionTextView.text;
    NSNumber *userIdentifier = self.recipient.identifier;
    
    [self createMessageWithUserIdentifier:userIdentifier content:content];
    
}

- (void)createMessageWithUserIdentifier:(NSNumber *)userIdentifier content:(NSString *)content
{
    NBAPINetworkOperation *publishOperation = [NBAPIRequest sendMessageToUser:userIdentifier withContent:content];
    
    [publishOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NBAPIResponseMessage *response = (NBAPIResponseMessage *)operation.APIResponse;
        if ([self.delegate respondsToSelector:@selector(newMessageViewController:didSendMessage:creatingConversation:)])
            [self.delegate newMessageViewController:self didSendMessage:response.message creatingConversation:response.conversation];
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
