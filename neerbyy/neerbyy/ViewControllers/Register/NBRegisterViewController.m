//
//  NBRegisterViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 26/01/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBRegisterViewController.h"
#import "NBUser.h"

@interface NBRegisterViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet NBTextField *usernameTextField;
@property (strong, nonatomic) IBOutlet NBTextField *emailTextField;
@property (strong, nonatomic) IBOutlet NBTextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *pickImageButton;

@property (strong, nonatomic) UIImage *avatar;

@end

@implementation NBRegisterViewController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pickImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.usernameTextField.textFieldType = kNBTextFieldTypeUsername;
    self.emailTextField.textFieldType = kNBTextFieldTypeEmail;
    self.passwordTextField.textFieldType = kNBTextFieldTypePassword;
}

#pragma mark - User interactions

- (IBAction)tappedPictureButton:(id)sender
{
    [self showImagePicker];
}

- (IBAction)tappedValidationButton:(id)sender
{
    [self validateForm];
}

#pragma mark - NBGenericFormViewController

- (void)pickedImage:(UIImage *)image
{
    [self updateProfilePicture:image];
}

- (void)validateForm
{
    [super validateForm];
    [self disableValidationButton];
    [self registerUser];
}

#pragma mark - Response handlers

- (NBAPINetworkResponseSuccessHandler)registerHandler
{
    NBAPINetworkResponseSuccessHandler registerHandler = ^(NBAPINetworkOperation *completedOperation)
    {
        NBAPIResponseLogin *response = (NBAPIResponseLogin *)completedOperation.APIResponse;
        if (response.hasError)
        {
            [self enableValidationButtonIfNeeded];
            [self displayAlertErrorWithDescription:response.responseMessage];
            return ;
        }
        
        NBUser *loggedUser = response.user;
        loggedUser.password = self.passwordTextField.text;

        NBPersistanceManager *persistanceManager = [NBPersistanceManager sharedManager];
        persistanceManager.currentUser = loggedUser;

        [self goBackToLogin];
    };
    
    return registerHandler;
}

- (NBAPINetworkResponseErrorHandler)registerErrorHandler
{
    NBAPINetworkResponseErrorHandler registerErrorHandler = ^(NBAPINetworkOperation *completedOperation, NSError *error)
    {
        [self enableValidationButtonIfNeeded];
        super.defaultErrorHandler(completedOperation, error);
    };
    
    return registerErrorHandler;
}

#pragma mark - Changing view controller

- (void)goBackToLogin
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Convinience methods

- (void)registerUser
{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *email = self.emailTextField.text;
    UIImage *avatar = self.avatar;
    
    NBAPINetworkOperation *registerOperation = [NBAPIRequest registerWithUsername:username password:password email:email avatar:avatar];
    [registerOperation addCompletionHandler:[self registerHandler]
                               errorHandler:[self registerErrorHandler]];
    [registerOperation enqueue];
}

- (void)updateProfilePicture:(UIImage *)image
{
    self.avatar = image;
    [self.pickImageButton setImage:image forState:UIControlStateNormal];
}

@end
