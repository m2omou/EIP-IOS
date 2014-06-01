//
//  NBGenericFormViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 26/01/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBGenericFormViewController.h"
#import "UITextField+Required.h"

typedef enum { kImagePickerIndexCamera, kImagePickerIndexLibrary } kImagePickerIndex;


@interface NBGenericFormViewController () <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UITapGestureRecognizer *tapMainViewGestureRecognizer;

@property (strong, nonatomic) UIActionSheet *imagePickerActionSheet;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end


@implementation NBGenericFormViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.validateFormOnLastTextFieldValidation = YES;
    [self initTapGestureRecognizer];
    [self initTextFields];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self enableValidationButtonIfNeeded];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterForKeyboardNotifications];
}

- (void)initTapGestureRecognizer
{
    self.tapMainViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedMainView:)];
    [self.view addGestureRecognizer:self.tapMainViewGestureRecognizer];
}

- (void)initTextFields
{
    for (NBTextField *textField in self.textFields)
    {
        textField.delegate = self;
        [textField addTarget:self action:@selector(enableValidationButtonIfNeeded) forControlEvents:UIControlEventEditingChanged];
    }
}

- (void)registerForKeyboardNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

#pragma mark - NBGenericViewController

- (void)showSlidingMenu:(id)sender
{
    [self hideKeyboard];
    [super showSlidingMenu:sender];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSUInteger textFieldIndex = [self.textFields indexOfObject:textField];
    
    if (textFieldIndex != NSNotFound)
    {
        NSUInteger numberOfTextFields = self.textFields.count;
        NSUInteger nextTextFieldIndex = textFieldIndex + 1;
        if (nextTextFieldIndex < numberOfTextFields)
        {
            NBTextField *nextTextField = self.textFields[nextTextFieldIndex];
            [nextTextField becomeFirstResponder];
        }
        else
        {
            if ([self enableValidationButtonIfNeeded] &&
                self.validateFormOnLastTextFieldValidation)
                [self validateForm];
            else
                [self hideKeyboard];
        }
    }
    return YES;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.imagePickerActionSheet && buttonIndex != actionSheet.cancelButtonIndex)
        [self showImagePickerWithActionSheetIndex:(kImagePickerIndex)buttonIndex];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self pickedImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Public methods

- (void)disableValidationButton
{
    if ([self.validationButton respondsToSelector:@selector(setEnabled:)] == NO)
        return ;
    
    ((UIButton *)self.validationButton).enabled = NO;
}

- (BOOL)enableValidationButtonIfNeeded
{
    if ([self.validationButton respondsToSelector:@selector(setEnabled:)] == NO)
        return NO;
    
    BOOL canValidateForm = YES;
    
    for (NBTextField *textField in self.textFields)
    {
        if ([textField canReturn] == NO)
        {
            canValidateForm = NO;
            break ;
        }
    }
    
    if (canValidateForm && self.customValidation)
        canValidateForm = self.customValidation();

    ((UIButton *)self.validationButton).enabled = canValidateForm;

    return canValidateForm;
}

- (void)hideKeyboard
{
    for (NBTextField *textField in self.textFields)
        [textField resignFirstResponder];
}

- (void)validateForm
{
    [self hideKeyboard];
}

- (void)showImagePicker
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        [self showImagePickerActionSheet];
    else
        [self showImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)pickedImage:(UIImage *)image
{
    NSAssert(NO, @"This method should be subclassed");
}

#pragma mark - Private methods - UIImagePicker

- (void)showImagePickerActionSheet
{
    if (self.imagePickerActionSheet == nil)
    {
        self.imagePickerActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                         cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil
                                                         otherButtonTitles:@"Prendre photo",
                                                                           @"Bibliothèque",
                                                                           nil];
    }
    [self.imagePickerActionSheet showInView:self.view];
}

- (void)showImagePickerWithActionSheetIndex:(kImagePickerIndex)index
{
    UIImagePickerControllerSourceType source;

    switch (index)
    {
        case kImagePickerIndexCamera:
            source = UIImagePickerControllerSourceTypeCamera;
            break;
        case kImagePickerIndexLibrary:
            source = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
    }

    [self showImagePickerWithSource:source];
}

- (void)showImagePickerWithSource:(UIImagePickerControllerSourceType)source
{
    if (self.imagePickerController == nil)
    {
        self.imagePickerController = [UIImagePickerController new];
        self.imagePickerController.delegate = self;
    }

    self.imagePickerController.sourceType = source;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    /* Hack to fix iOS 7's UIImagePickerController breaking the status bar color */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


#pragma mark - Private methods - Keyboard related

- (void)keyboardWillShow:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
	CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIScrollView *scrollView = self.textFieldsScrollView;
	CGRect scrollViewFrame = [scrollView.window convertRect:scrollView.frame fromView:scrollView.superview];
    
	CGRect coveredFrame = CGRectIntersection(scrollViewFrame, keyboardFrame);
	coveredFrame = [scrollView.window convertRect:coveredFrame toView:scrollView.superview];
    
    CGFloat const bottomOffset = 10.f;
    CGFloat coveredHeight = CGRectGetHeight(coveredFrame);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, coveredHeight + bottomOffset, 0);
    
    CGFloat animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIScrollView *scrollView = self.textFieldsScrollView;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
	NSDictionary *userInfo = [notification userInfo];
    CGFloat animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)tappedMainView:(UITapGestureRecognizer *)gestureRecognizer
{
    [self hideKeyboard];
}

@end
