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

@interface NBProfileViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self themePickImageButton];
    [self themeDeleteAccountButton];
    [self fetchAvatar];
    [self fillFields];
}

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
    
    if (!user.avatarURL) {
        [self updateImagesWithImage:[UIImage imageNamed:@"img-add-avatar"]];
        return ;
    }

    [[NBAPINetworkEngine engine] imageAtURL:user.avatarURL completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        [self updateImagesWithImage:fetchedImage];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self updateImagesWithImage:[UIImage imageNamed:@"img-add-avatar"]];
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

- (void)updateImagesWithImage:(UIImage *)image
{
    [UIView animateWithDuration:.3f animations:^{
        [self.pickImageButton setImage:image forState:UIControlStateNormal];
        self.backgroundView.image = image;
    }];
}

- (void)updateProfilePicture:(UIImage *)image
{
    self.avatar = image;
    [self updateImagesWithImage:image];
}

- (IBAction)tappedPictureButton:(id)sender
{
    [self showImagePicker];
}

- (IBAction)tappedValidationButton:(id)sender
{
    [self validateForm];
}

- (void)validateForm
{
    [super validateForm];
    
    if ([self wantsToChangePassword] && [self currentPasswordMatches] == NO)
    {
        [[[UIAlertView alloc] initWithTitle:@"Oups !"
                                    message:@"Le mot de passe actuel semble invalide. Veuillez réessayer"
                                   delegate:nil
                          cancelButtonTitle:@"Annuler"
                          otherButtonTitles:nil]
         show];
        return ;
    }
    
    NSString *firstName = self.firstNameTextField.text;
    NSString *lastName = self.lastNameTextField.text;
    NSString *username = self.usernameTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *password = self.updatedPasswordTextField.text;
    UIImage *avatar = self.avatar;
    
    NBAPINetworkOperation *profileOperation = [NBAPIRequest updateFirstName:firstName lastName:lastName username:username
                                                                      email:email password:password avatar:avatar];
    [profileOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        [self enableValidationButtonIfNeeded];
        self.currentPasswordTextField.text = self.updatedPasswordTextField.text = @"";
        
        NBAPIResponseUser *response = (NBAPIResponseUser *)operation.APIResponse;
        NBUser *user = response.user;

        if (!user)
            return [NBAPINetworkOperation defaultErrorHandler](operation, nil);
        
        self.persistanceManager.currentUser = user;
        if (password.length)
            self.persistanceManager.currentUserPassword = password;
    } errorHandler:^(NBAPINetworkOperation *operation, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](operation, error);
        [self enableValidationButtonIfNeeded];
    }];

    [self disableValidationButton];
    [profileOperation enqueue];
}

- (BOOL)wantsToChangePassword
{
    return self.updatedPasswordTextField.text.length > 0;
}

- (BOOL)currentPasswordMatches
{
    return [self.currentPasswordTextField.text isEqualToString:self.persistanceManager.currentUserPassword];
}

@end
