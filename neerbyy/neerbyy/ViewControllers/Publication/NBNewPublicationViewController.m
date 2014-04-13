//
//  NBNewPublicationViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 06/04/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBNewPublicationViewController.h"
#import "NBUser.h"


@interface NBNewPublicationViewController ()

@property (strong, nonatomic) IBOutlet NBPrimaryButton *pickImageButton;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomConstraint;

@property (strong, nonatomic) UIImage *image;

@end


@implementation NBNewPublicationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self themePickImageButton];
    [self themeDescriptionTextView];
}

#pragma mark - Theming

- (void)themePickImageButton
{
    self.pickImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)themeDescriptionTextView
{
    self.descriptionTextView.tintColor = self.theme.lightGreenColor;
}

#pragma mark - User interactions

- (IBAction)pressedImageButton:(id)sender
{
    [self showImagePicker];
}

- (IBAction)tappedValidationButton:(id)sender
{
    [self validateForm];
}

- (IBAction)tappedCancelButton:(id)sender
{
    [self dismiss];
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
    [self createPublication];
}

#pragma mark - UIBarPositioningDelegate

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#pragma mark - Convinience methods

- (void)createPublication
{
    if (!self.persistanceManager.isConnected)
    {
        [self warnIfNotConnected];
        return ;
    }
    
    UIImage *image = self.image;
    NSString *description = self.descriptionTextView.text;
    NSString *placeIdentifier = self.place.identifier;
    [self createPublicationWithPlaceIdentifier:placeIdentifier image:image description:description];
}

- (void)createPublicationWithPlaceIdentifier:(NSString *)placeIdentifier image:(UIImage *)image description:(NSString *)description
{
    NBAPINetworkOperation *publishOperation = [NBAPIRequest createPublicationOnPlace:placeIdentifier withImage:image description:description];
    
    [publishOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        [self dismiss];
    } errorHandler:^(NBAPINetworkOperation *operation, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](operation, error);
        [self enableValidationButtonIfNeeded];
    }];

    [publishOperation enqueue];
}

- (void)updateProfilePicture:(UIImage *)image
{
    self.image = image;
    [self.pickImageButton setImage:image forState:UIControlStateNormal];
}

- (void)warnIfNotConnected
{
    [[[UIAlertView alloc] initWithTitle:@"Oups"
                                message:@"Il faut être connecté pour pouvoir ajouter des souvenirs !"
                               delegate:nil
                      cancelButtonTitle:@"Annuler"
                      otherButtonTitles:@"Créer un compte", nil] show];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
