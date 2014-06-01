//
//  NBGenericFormViewController.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 26/01/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBGenericViewController.h"
#import "NBTextField.h"

typedef BOOL (^NBGenericFormViewControllerValidationBlock)();

@interface NBGenericFormViewController : NBGenericViewController

@property (assign, nonatomic) BOOL validateFormOnLastTextFieldValidation;
@property (strong, nonatomic) NBGenericFormViewControllerValidationBlock customValidation;

@property (strong, nonatomic) IBOutlet UIScrollView *textFieldsScrollView;
@property (strong, nonatomic) IBOutletCollection(NBTextField) NSArray *textFields;
@property (strong, nonatomic) IBOutlet NSObject *validationButton;

- (void)tappedMainView:(UITapGestureRecognizer *)gestureRecognizer;
- (void)hideKeyboard;
- (void)disableValidationButton;
- (BOOL)enableValidationButtonIfNeeded;
- (void)validateForm;

- (void)showImagePicker;
- (void)pickedImage:(UIImage *)image;

@end
