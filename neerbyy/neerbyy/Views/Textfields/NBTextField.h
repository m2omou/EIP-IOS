//
//  NBTextField.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 25/01/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

typedef enum {
    kNBTextFieldTypeUnknown,
    kNBTextFieldTypeUsername,
    kNBTextFieldTypeEmail,
    kNBTextFieldTypePassword
} NBTextFieldType;

@interface NBTextField : UITextField

@property (assign, nonatomic) NBTextFieldType textFieldType;

- (void)setFullTextColor:(UIColor *)textColor;

@end
