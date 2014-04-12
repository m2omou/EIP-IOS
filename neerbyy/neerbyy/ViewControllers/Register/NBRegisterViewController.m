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

    [self themeTextFields];
}

#pragma mark - Theming

- (void)themeTextFields
{
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

#pragma mark - Convinience methods

- (void)registerUser
{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *email = self.emailTextField.text;
    UIImage *avatar = self.avatar;
    
    NBAPINetworkOperation *registerOperation = [NBAPIRequest registerWithUsername:username password:password email:email avatar:avatar];

    [registerOperation addCompletionHandler:^(NBAPINetworkOperation *completedOperation) {
        NBAPIResponseUser *response = (NBAPIResponseUser *)completedOperation.APIResponse;
        [self setupCurrentUserAndGoBackToLogin:response.user];
    } errorHandler:^(NBAPINetworkOperation *completedOperation, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](completedOperation, error);
        [self enableValidationButtonIfNeeded];
    }];
    
    [registerOperation enqueue];
}

- (void)updateProfilePicture:(UIImage *)image
{
    self.avatar = image;
    [self.pickImageButton setImage:image forState:UIControlStateNormal];
}

- (void)setupCurrentUserAndGoBackToLogin:(NBUser *)user
{
    self.persistanceManager.currentUser = user;
    [self goBackToLogin];
}

- (void)goBackToLogin
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
