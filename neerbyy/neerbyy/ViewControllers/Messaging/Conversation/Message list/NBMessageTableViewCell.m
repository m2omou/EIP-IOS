//
//  NBMessageTableViewCell.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBMessageTableViewCell.h"
#import "NBTheme.h"

@interface NBMessageTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet NBLabel *messageLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewTrailingConstraint;

@end


@implementation NBMessageTableViewCell

#pragma mark - Public methods

+ (CGFloat)heightForMessage:(NBMessage *)message width:(CGFloat)width
{
    static CGFloat const totalHeightPadding = 35.f;
    static CGFloat const totalWidthPadding = 90.f;

    CGFloat labelHeight = CGRectGetHeight([message.content boundingRectWithSize:CGSizeMake(width - totalWidthPadding, 0)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName: [[NBTheme sharedTheme].font fontWithSize:12.f]}
                                                                        context:nil]);
    CGFloat height = labelHeight + totalHeightPadding;
    
    return height;
}

- (void)configureWithMessage:(NBMessage *)message
{
    BOOL isFromCurrentUser = [message isFromCurrentUser];

    [self themeCellWithSender:isFromCurrentUser];
    [self configureMessageLabelWithContent:message.content];
}

- (void)themeCellWithSender:(BOOL)isSenderCurrentUser
{
    NBTheme *theme = [NBTheme sharedTheme];
    NSTextAlignment alignment;
    UIColor *backgroundColor;
    UIColor *foregourndColor;
    CGFloat leadingSpace;
    CGFloat trailingSpace;
    
    if (isSenderCurrentUser)
    {
        alignment = NSTextAlignmentRight;
        backgroundColor = theme.lightGreenColor;
        foregourndColor = theme.whiteColor;
        leadingSpace = 80.f;
        trailingSpace = 10.f;
    }
    else
    {
        alignment = NSTextAlignmentLeft;
        backgroundColor = theme.beigeColor;
        foregourndColor = theme.darkGrayColor;
        leadingSpace = 10.f;
        trailingSpace = 80.f;
    }
    
    self.messageLabel.textAlignment = alignment;
    self.backgroundImageView.backgroundColor = backgroundColor;
    self.messageLabel.textColor = foregourndColor;
    self.imageViewLeadingConstraint.constant = leadingSpace;
    self.imageViewTrailingConstraint.constant = trailingSpace;
    
    [self layoutIfNeeded];
}

- (void)configureMessageLabelWithContent:(NSString *)content
{
    self.messageLabel.text = content;
}

#pragma mark - NBTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundImageView.layer.cornerRadius = 5.f;
}

- (void)setHighlighted:(BOOL)highlighted
{ }

@end
