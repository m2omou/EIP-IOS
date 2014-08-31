//
//  NBForgotPasswordViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 01/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBForgotPasswordViewController.h"
#import <GAI.h>
#import <GAIFields.h>
#import <GAIDictionaryBuilder.h>


@interface NBForgotPasswordViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *validationButton;
@property (strong, nonatomic) IBOutlet NBTextField *emailTextField;

@end


@implementation NBForgotPasswordViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self themeEmailTextField];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Forgot password"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - Theming

- (void)themeEmailTextField
{
    self.emailTextField.textFieldType = kNBTextFieldTypeEmail;
}

#pragma mark - User interactions

- (IBAction)tappedValidationButton:(id)sender
{
    [self validateForm];
}

#pragma mark - NBGenericFormViewController

- (void)validateForm
{
    [super validateForm];
    [self disableValidationButton];
    [self sendForgotPasswordEmail];
}

#pragma mark - Private methods

- (void)sendForgotPasswordEmail
{
    NSString *email = self.emailTextField.text;
    
    NBAPINetworkOperation *forgotPasswordOperation = [NBAPIRequest sendForgetPasswordWithEmail:email];

    [forgotPasswordOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        [self displayAlertWithTitle:@"Email envoyé !"
                        description:@"Vous devriez recevoir un email de confirmation dans quelques instants afin de réinitialiser votre mot de passe"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } errorHandler:^(NBAPINetworkOperation *operation, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](operation, error);
        [self enableValidationButtonIfNeeded];
    }];
    
    [forgotPasswordOperation enqueue];

}

@end
