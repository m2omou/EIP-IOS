//
//  NBProfileViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 28/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBProfileViewController.h"
#import "NBCircleImageView.h"
#import "NBBlurredZoomedImageView.h"
#import "NBUser.h"
#import "NBAppDelegate.h"

@interface NBProfileViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet NBPrimaryButton *pickImageButton;
@property (strong, nonatomic) IBOutlet NBBlurredZoomedImageView *backgroundView;
@property (strong, nonatomic) IBOutlet NBTextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet NBTextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet NBTextField *usernameTextField;
@property (strong, nonatomic) IBOutlet NBTextField *emailTextField;
@property (strong, nonatomic) IBOutlet NBTextField *currentPasswordTextField;
@property (strong, nonatomic) IBOutlet NBTextField *updatedPasswordTextField;
@property (strong, nonatomic) IBOutlet NBPrimaryButton *deleteAccountButton;

@property (strong, nonatomic) UIImage *avatar;

@end

@implementation NBProfileViewController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self themePickImageButton];
    [self themeDeleteAccountButton];
    [self fetchAvatar];
    [self fillFields];
}

#pragma mark - Theming

- (void)themeDeleteAccountButton
{
    self.deleteAccountButton.backgroundColor = self.theme.orangeColor;
}

- (void)themePickImageButton
{
    self.pickImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)fetchAvatar
{
    NBUser *user = self.persistanceManager.currentUser;
    
    [[NBAPINetworkEngine engine] imageAtURL:user.avatarURL completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        [self updateImagesWithImage:fetchedImage];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](nil, error);
    }];
}

- (void)fillFields
{
    NBUser *user = self.persistanceManager.currentUser;

    self.firstNameTextField.text = user.firstname;
    self.lastNameTextField.text = user.lastname;
    self.emailTextField.text = user.email;
    self.usernameTextField.text = user.username;
}

#pragma mark - NBGenericFormViewController

- (void)validateForm
{
    [super validateForm];
    
    if ([self wantsToChangePassword] && [self currentPasswordMatches] == NO)
    {
        [self warnCurrentPasswordDoesntMatch];
        return ;
    }
    
    NSString *firstName = self.firstNameTextField.text;
    NSString *lastName = self.lastNameTextField.text;
    NSString *username = self.usernameTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *password = self.updatedPasswordTextField.text;
    UIImage *avatar = self.avatar;
    
    [self updateUserWithFirstName:firstName lastName:lastName username:username email:email password:password avatar:avatar];
}

- (void)pickedImage:(UIImage *)image
{
    self.avatar = image;
    [self updateImagesWithImage:image];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [self deleteAccount];
    }
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

- (IBAction)tappedDeleteAccountButton:(id)sender
{
    [self displayConfirmDeleteAccountAlertView];
}

#pragma mark - Convenience methods

- (void)updateImagesWithImage:(UIImage *)image
{
    [UIView animateWithDuration:.3f animations:^{
        [self.pickImageButton setImage:image forState:UIControlStateNormal];
        self.backgroundView.image = image;
    }];
}

- (BOOL)wantsToChangePassword
{
    return self.updatedPasswordTextField.text.length > 0;
}

- (BOOL)currentPasswordMatches
{
    return [self.currentPasswordTextField.text isEqualToString:self.persistanceManager.currentUserPassword];
}

- (void)warnCurrentPasswordDoesntMatch
{
    [[[UIAlertView alloc] initWithTitle:@"Oups !"
                                message:@"Le mot de passe actuel semble invalide. Veuillez réessayer"
                               delegate:nil
                      cancelButtonTitle:@"Annuler"
                      otherButtonTitles:nil]
     show];
}

- (void)resetForm
{
    [self enableValidationButtonIfNeeded];
    self.currentPasswordTextField.text = self.updatedPasswordTextField.text = @"";
}

- (void)updateUserWithFirstName:(NSString *)firstName lastName:(NSString *)lastName username:(NSString *)username
                          email:(NSString *)email password:(NSString *)password avatar:(UIImage *)avatar
{
    NBAPINetworkOperation *profileOperation = [NBAPIRequest updateFirstName:firstName lastName:lastName username:username
                                                                      email:email password:password avatar:avatar];

    [profileOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        [self resetForm];
        
        NBAPIResponseUser *response = (NBAPIResponseUser *)operation.APIResponse;
        NBUser *user = response.user;
        if (!user)
            return [NBAPINetworkOperation defaultErrorHandler](operation, nil);
        
        [self updateCurrentUserWithUser:user password:self.updatedPasswordTextField.text];
    } errorHandler:^(NBAPINetworkOperation *operation, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](operation, error);
        [self resetForm];
    }];
    
    [self disableValidationButton];
    [profileOperation enqueue];
}

- (void)updateCurrentUserWithUser:(NBUser *)user password:(NSString *)password
{
    self.persistanceManager.currentUser = user;

    if (password.length)
        self.persistanceManager.currentUserPassword = password;
}

- (void)displayConfirmDeleteAccountAlertView
{
    [[[UIAlertView alloc] initWithTitle:@"Suppression de compte"
                                message:@"Cette action ne peut pas être annulée, supprimera tous vos souvenirs, commentaires et préférences"
                               delegate:self
                      cancelButtonTitle:@"Annuler"
                      otherButtonTitles:@"Supprimer", nil]
     show];
}

- (void)deleteAccount
{
    NBAPINetworkOperation *deleteAccountOperation = [NBAPIRequest deleteAccount];
    
    [deleteAccountOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NBAppDelegate *appDelegate = (NBAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate logoutUser];
    } errorHandler:[NBAPINetworkOperation defaultErrorHandler]];
    [deleteAccountOperation enqueue];
}

@end
