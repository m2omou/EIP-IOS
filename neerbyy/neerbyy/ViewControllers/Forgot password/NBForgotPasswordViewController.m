//
//  NBForgotPasswordViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 01/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBForgotPasswordViewController.h"


@interface NBForgotPasswordViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *validationButton;
@property (strong, nonatomic) IBOutlet NBTextField *emailTextField;

@end


@implementation NBForgotPasswordViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

#pragma mark - Response handlers

- (NBAPINetworkResponseSuccessHandler)forgotPasswordHandler
{
    NBAPINetworkResponseSuccessHandler forgotPasswordHandler = ^(NBAPINetworkOperation *completedOperation)
    {
        NBAPIResponse *APIResponse = completedOperation.APIResponse;
        if (APIResponse.hasError)
        {
            [self enableValidationButtonIfNeeded];
            [self displayAlertErrorWithDescription:APIResponse.responseMessage];
            return ;
        }
        
        [self displayAlertWithTitle:@"Email envoyé !"
                        description:@"Vous devriez recevoir un email de confirmation dans quelques instants afin de réinitialiser votre mot de passe"];
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    return forgotPasswordHandler;
}

- (NBAPINetworkResponseErrorHandler)forgotPasswordErrorHandler
{
    NBAPINetworkResponseErrorHandler forgortPasswordErrorHandler = ^(NBAPINetworkOperation *completedOperation, NSError *error)
    {
        [self enableValidationButtonIfNeeded];
        super.defaultErrorHandler(completedOperation, error);
    };
    return forgortPasswordErrorHandler;
}

#pragma mark - Private methods

- (void)sendForgotPasswordEmail
{
    NSString *email = self.emailTextField.text;
    
    NBAPINetworkOperation *forgotPasswordOperation = [NBAPIRequest sendForgetPasswordWithEmail:email];
    [forgotPasswordOperation addCompletionHandler:[self forgotPasswordHandler]
                                     errorHandler:[self forgotPasswordErrorHandler]];
    [forgotPasswordOperation enqueue];

}

@end
