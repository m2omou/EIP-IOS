//
//  NBGenericFormViewController.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 26/01/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBGenericViewController.h"
#import "NBTextField.h"


@interface NBGenericFormViewController : NBGenericViewController

@property (strong, nonatomic) IBOutlet UIScrollView *textFieldsScrollView;
@property (strong, nonatomic) IBOutletCollection(NBTextField) NSArray *textFields;
@property (strong, nonatomic) IBOutlet NSObject *validationButton;

- (void)hideKeyboard;
- (void)disableValidationButton;
- (BOOL)enableValidationButtonIfNeeded;
- (void)validateForm;

- (void)showImagePicker;
- (void)pickedImage:(UIImage *)image;

@end
