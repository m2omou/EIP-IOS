//
//  NBLoginViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 24/01/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBLoginViewController.h"
#import "NBUser.h"

@interface NBLoginViewController ()

@property (strong, nonatomic) IBOutlet NBTextField *usernameTextField;
@property (strong, nonatomic) IBOutlet NBTextField *passwordTextField;
@property (strong, nonatomic) IBOutlet NBPrimaryButton *validationButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *connectionActivityIndicator;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *validationButtonLeadingSpaceConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *validationButtonTrailingSpaceConstraint;

@end

@implementation NBLoginViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hidesNavigationBar = YES;
    
    [self themeTextFieldsView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fillFormWithCurrentUserDataAndTryToConnect];
}

- (void)themeTextFieldsView
{
    NBTheme *theme = [NBTheme sharedTheme];
    
    self.connectionActivityIndicator.color = theme.lightGrayColor;
    self.usernameTextField.textFieldType = kNBTextFieldTypeEmail;
    self.passwordTextField.textFieldType = kNBTextFieldTypePassword;
}

#pragma mark - NBGenericFormViewController

- (void)validateForm
{
    [super validateForm];
    [self animateAndTryToConnect];
}

#pragma mark - User interactions

- (IBAction)pressedValidationButton:(UIButton *)sender
{
    [self validateForm];
}

- (IBAction)pressedContinueAsGuestButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private methods - Reponse handlers

- (NBAPINetworkResponseSuccessHandler)loggedInHandler
{
    NBAPINetworkResponseSuccessHandler loggedInHandler = ^(NBAPINetworkOperation *completedOperation)
    {
        NBAPIResponseLogin *response = (NBAPIResponseLogin *)completedOperation.APIResponse;
        if (response.hasError)
        {
            [self resetConnectionAnimation];
            [self displayAlertErrorWithDescription:response.responseMessage];
            return ;
        }

        NBUser *loggedUser = response.user;
        loggedUser.password = self.passwordTextField.text;

        NBPersistanceManager *persistanceManager = [NBPersistanceManager sharedManager];
        persistanceManager.currentUser = loggedUser;

        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    return loggedInHandler;
}

- (NBAPINetworkResponseErrorHandler)loggedInErrorHandler
{
    NBAPINetworkResponseErrorHandler defaultErrorHandler = ^(NBAPINetworkOperation *completedOperation, NSError *error)
    {
        [self resetConnectionAnimation];
        super.defaultErrorHandler(completedOperation, error);
    };
    
    return defaultErrorHandler;
}

#pragma mark - Private methods - Connection

- (void)fillFormWithCurrentUserDataAndTryToConnect
{
    NBPersistanceManager *persistanceManager = [NBPersistanceManager sharedManager];
    NBUser *currentUser = persistanceManager.currentUser;
    
    if (currentUser != nil)
    {
        self.usernameTextField.text = currentUser.username;
        self.passwordTextField.text = currentUser.password;
        
        [self validateForm];
    }
}

- (void)tryToConnect
{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [self tryToConnectWithUsername:username password:password];
}

- (void)tryToConnectWithUsername:(NSString *)username password:(NSString *)password
{
    NBAPINetworkOperation *loginOperation = [NBAPIRequest loginWithUsername:username password:password];
    [loginOperation addCompletionHandler:[self loggedInHandler]
                            errorHandler:[self loggedInErrorHandler]];
    [loginOperation enqueue];
}

#pragma mark - Private methods - Animations

- (void)animateAndTryToConnect
{
    self.validationButton.userInteractionEnabled = NO;
    
    self.validationButtonLeadingSpaceConstraint.constant = 250;
    [UIView animateWithDuration:.4f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.validationButton layoutIfNeeded];
        [self.validationButton setImage:[UIImage imageNamed:@"ic-password"] forState:UIControlStateNormal];
        [self.validationButton setTitle:@"" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        self.validationButtonLeadingSpaceConstraint.constant = 125;
        self.validationButtonTrailingSpaceConstraint.constant = -125;
        [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.validationButton layoutIfNeeded];
            [self.connectionActivityIndicator startAnimating];
            [self.connectionActivityIndicator layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self tryToConnect];
        }];
    }];
}

- (void)resetConnectionAnimation
{
    self.validationButtonLeadingSpaceConstraint.constant = 0;
    self.validationButtonTrailingSpaceConstraint.constant = 0;

    [self.connectionActivityIndicator stopAnimating];
    [UIView animateWithDuration:.5f animations:^{
        [self.validationButton layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.validationButton setTitle:@"CONNECTER" forState:UIControlStateNormal];
        [self.validationButton setImage:nil forState:UIControlStateNormal];
        
        self.validationButton.userInteractionEnabled = YES;
    }];
}

@end
