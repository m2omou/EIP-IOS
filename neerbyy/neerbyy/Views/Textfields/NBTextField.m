//
//  NBTextField.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 25/01/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBTextField.h"
#import "NBTheme.h"


@implementation NBTextField

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self)
    {
        NBTheme *theme = [NBTheme sharedTheme];

        self.font = theme.font;
        self.backgroundColor = theme.darkWhiteColor;
        self.tintColor = theme.lightGreenColor;
        [self setFullTextColor:theme.darkGrayColor];
        self.layer.cornerRadius = self.frame.size.height / 2.f;
    }

    return self;
}

#pragma mark - Public methods

- (void)setFullTextColor:(UIColor *)textColor
{
    self.textColor = textColor;
    [self setPlaceHolderColor:textColor];
}

- (void)setTextFieldType:(NBTextFieldType)textFieldType
{
    _textFieldType = textFieldType;
    
    UIView *leftView;

    switch (textFieldType) {
        case kNBTextFieldTypeUsername:
            leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-user"]];
            break;
            
        case kNBTextFieldTypeEmail:
            leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-mail"]];
            break;

        case kNBTextFieldTypePassword:
            leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-password"]];
            
        default:
            break;
    }
    
    if (leftView != nil)
    {
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
}

#pragma mark - UITextField

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGFloat xOffset = self.layer.cornerRadius;
    CGFloat yOffset = 2.f;
    
    if (self.leftView != nil)
    {
        CGFloat leftViewWidth = CGRectGetWidth(self.leftView.frame);
        xOffset += leftViewWidth;
    }
    
    CGRect placeHolderRect = CGRectOffset(bounds, xOffset, yOffset);
    return placeHolderRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [self placeholderRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self placeholderRectForBounds:bounds];
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGFloat xOffset = self.layer.cornerRadius / 2.f;
    CGFloat yOffset = (CGRectGetHeight(bounds) - CGRectGetHeight(self.leftView.frame)) / 2.f;
    CGSize leftViewSize = self.leftView.frame.size;
    
    CGRect leftViewRect = CGRectMake(xOffset, yOffset, leftViewSize.width, leftViewSize.height);
    return leftViewRect;
}

#pragma mark - Convenience methods

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    NSString *placeHolder = self.placeholder ? self.placeholder : @"";
    NSDictionary *placeHolderAttributes = @{NSForegroundColorAttributeName:placeHolderColor};
    NSAttributedString *attributedPlaceHolder = [[NSAttributedString alloc] initWithString:placeHolder attributes:placeHolderAttributes];

    self.attributedPlaceholder = attributedPlaceHolder;
}

@end

