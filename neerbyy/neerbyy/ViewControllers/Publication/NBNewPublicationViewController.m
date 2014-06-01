//
//  NBNewPublicationViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 06/04/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBNewPublicationViewController.h"
#import "UITextField+Required.h"
#import "NBLabel.h"
#import "NBUser.h"

typedef enum : NSUInteger {
    kNBPublicationSegmentImage,
    kNBPublicationSegmentText,
    kNBPublicationSegmentLink,
} NBPublicationSegment;


@interface NBNewPublicationViewController ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (strong, nonatomic) IBOutlet NBTextField *urlTextField;
@property (strong, nonatomic) IBOutlet NBPrimaryButton *pickImageButton;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet NBLabel *descriptionPlaceholder;
@property (strong, nonatomic) NSLayoutConstraint *textViewTopConstraint;

@property (strong, nonatomic) UIImage *image;

@end


@implementation NBNewPublicationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.validateFormOnLastTextFieldValidation = NO;
    __weak NBNewPublicationViewController *weakSelf = self;
    self.customValidation = ^BOOL{
        if (weakSelf.descriptionTextView.text.length == 0)
            return NO;
        
        if (weakSelf.typeSegmentedControl.selectedSegmentIndex == kNBPublicationSegmentImage &&
            weakSelf.image == nil)
            return NO;
        
        return YES;
    };
    [self themePickImageButton];
    [self themeDescriptionTextView];
    [self changedSegmentedControlIndex:nil];
}

#pragma mark - Theming

- (void)themePickImageButton
{
    self.pickImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)themeDescriptionTextView
{
    UIColor *textColor = self.theme.lightGreenColor;

    self.descriptionPlaceholder.textColor = textColor;
    self.descriptionTextView.tintColor = textColor;
}

#pragma mark - User interactions

- (IBAction)changedSegmentedControlIndex:(id)sender
{
    NSUInteger selectedIndex = self.typeSegmentedControl.selectedSegmentIndex;
    [self changeFormContentWithType:selectedIndex];
}

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
    if ([self.delegate respondsToSelector:@selector(newPublicationViewControllerDidDismiss:)])
        [self.delegate newPublicationViewControllerDidDismiss:self];
    [self dismiss];
}

#pragma mark - NBGenericFormViewController

- (void)pickedImage:(UIImage *)image
{
    [self changeUploadPicture:image];
    [self enableValidationButtonIfNeeded];
}

- (void)validateForm
{
    [super validateForm];
    [self.descriptionTextView resignFirstResponder];
    [self disableValidationButton];
    [self createPublication];
}

- (void)tappedMainView:(UITapGestureRecognizer *)gestureRecognizer
{
    [super tappedMainView:gestureRecognizer];
    [self.descriptionTextView resignFirstResponder];
}

#pragma mark - UIBarPositioningDelegate

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView;
{
    BOOL hidePlaceHolder = (self.descriptionTextView.text.length > 0);
    self.descriptionPlaceholder.hidden = hidePlaceHolder;

    [self enableValidationButtonIfNeeded];
}

#pragma mark - Convinience methods

- (void)changeFormContentWithType:(NBPublicationSegment)type
{
    [self hideKeyboard];
    [self.descriptionTextView resignFirstResponder];
    
    switch (type) {
        case kNBPublicationSegmentLink:
            [self displayLinkForm];
            break;
            
        case kNBPublicationSegmentText:
            [self displayTextForm];
            break;
            
        case kNBPublicationSegmentImage:
            [self displayImageForm];
            break;
            
        default:
            break;
    }
    [self enableValidationButtonIfNeeded];
}

- (void)displayLinkForm
{
    self.urlTextField.isRequired = YES;
    self.urlTextField.alpha = 0.f;
    self.urlTextField.hidden = NO;
    [self pinTextViewTopToView:self.urlTextField];
    [UIView animateWithDuration:.2f animations:^{
        self.pickImageButton.alpha = 0.f;
        self.urlTextField.alpha = 1.f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.pickImageButton.hidden = YES;
    }];
}

- (void)displayTextForm
{
    self.urlTextField.isRequired = NO;
    [self pinTextViewTopToView:self.typeSegmentedControl];
    [UIView animateWithDuration:.2f animations:^{
        self.urlTextField.alpha = 0.f;
        self.pickImageButton.alpha = 0.f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.urlTextField.hidden = YES;
        self.pickImageButton.hidden = YES;
    }];
}

- (void)displayImageForm
{
    self.urlTextField.isRequired = NO;
    self.pickImageButton.alpha = 0.f;
    self.pickImageButton.hidden = NO;
    [self pinTextViewTopToView:self.pickImageButton];
    [UIView animateWithDuration:.2f animations:^{
        self.urlTextField.alpha = 0.f;
        self.pickImageButton.alpha = 1.f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.urlTextField.hidden = YES;
    }];
}

- (void)pinTextViewTopToView:(UIView *)view
{
    NSLayoutConstraint *newTopConstraint = [NSLayoutConstraint constraintWithItem:self.descriptionTextView
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:view
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.f
                                                                         constant:20.f];
    [self.view removeConstraint:self.textViewTopConstraint];
    self.textViewTopConstraint = newTopConstraint;
    [self.view addConstraint:self.textViewTopConstraint];
}

- (void)createPublication
{
    NSString *description = self.descriptionTextView.text;
    NSString *placeIdentifier = self.place.identifier;
    
    NBAPINetworkOperation *publishOperation;
    if (self.typeSegmentedControl.selectedSegmentIndex == kNBPublicationSegmentImage)
    {
        UIImage *image = self.image;
        publishOperation = [NBAPIRequest createPublicationOnPlace:placeIdentifier atPosition:self.place.coordinate withImage:image description:description];
    }
    else if (self.typeSegmentedControl.selectedSegmentIndex == kNBPublicationSegmentLink)
    {
        NSString *url = self.urlTextField.text;
        publishOperation = [NBAPIRequest createPublicationOnPlace:placeIdentifier atPosition:self.place.coordinate withURL:url description:description];
    }
    else
        publishOperation = [NBAPIRequest createPublicationOnPlace:placeIdentifier atPosition:self.place.coordinate withDescription:description];

    [publishOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NBAPIResponsePublication *response = (NBAPIResponsePublication *)operation.APIResponse;
        if ([self.delegate respondsToSelector:@selector(newPublicationViewController:didPublishPublication:)])
            [self.delegate newPublicationViewController:self didPublishPublication:response.publication];
        [self dismiss];
    } errorHandler:^(NBAPINetworkOperation *operation, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](operation, error);
        [self enableValidationButtonIfNeeded];
    }];
    
    [publishOperation enqueue];
}

- (void)changeUploadPicture:(UIImage *)image
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
