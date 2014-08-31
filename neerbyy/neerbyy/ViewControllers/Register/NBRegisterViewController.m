//
//  NBRegisterViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 26/01/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBRegisterViewController.h"
#import "NBLoginViewController.h"
#import "NBUser.h"
#import <GAI.h>
#import <GAIFields.h>
#import <GAIDictionaryBuilder.h>

@interface NBRegisterViewController ()

@property (strong, nonatomic) IBOutlet NBTextField *usernameTextField;
@property (strong, nonatomic) IBOutlet NBTextField *emailTextField;
@property (strong, nonatomic) IBOutlet NBTextField *passwordTextField;
@property (strong, nonatomic) IBOutlet NBPrimaryButton *pickImageButton;

@property (strong, nonatomic) UIImage *avatar;

@end


@implementation NBRegisterViewController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self themePickImageButton];
    [self themeTextFields];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Register"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - Theming

- (void)themePickImageButton
{
    self.pickImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)themeTextFields
{
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
        [self setupAndGoBackToLoginWithCurrentUser:response.user password:self.passwordTextField.text];
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

- (void)setupAndGoBackToLoginWithCurrentUser:(NBUser *)user password:(NSString *)password
{
    NBPersistanceManager *persistanceManager = self.persistanceManager;
    persistanceManager.currentUser = user;
    persistanceManager.currentUserPassword = password;
    
    [self goBackToLogin];
}

- (void)goBackToLogin
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
