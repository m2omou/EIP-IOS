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
    
    if (self.persistanceManager.isConnected)
        [self fillFormWithCurrentUserAndTryToConnect];
}

#pragma mark - Theming

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
    [self dismiss];
}

#pragma mark - Private methods - Connection

- (void)fillFormWithCurrentUserAndTryToConnect
{
    NBPersistanceManager *persistanceManager = self.persistanceManager;
    self.usernameTextField.text = persistanceManager.currentUser.username;
    self.passwordTextField.text = persistanceManager.currentUserPassword;
    
    [self animateAndTryToConnect];
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

    [loginOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponseUser *response = (NBAPIResponseUser *)completedOperation.APIResponse;

        [self setupAndDismissWithCurrentUser:response.user password:self.passwordTextField.text];
        
    } errorHandler:^(NBAPINetworkOperation *operation, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](operation, error);
        [self resetConnectionAnimation];
    }];

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

#pragma mark - Private method - Others

- (void)setupAndDismissWithCurrentUser:(NBUser *)user password:(NSString *)password
{
    NBPersistanceManager *persistanceManager = self.persistanceManager;
    persistanceManager.currentUser = user;
    persistanceManager.currentUserPassword = password;

    [self dismiss];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:self.onDismiss];
}

@end
