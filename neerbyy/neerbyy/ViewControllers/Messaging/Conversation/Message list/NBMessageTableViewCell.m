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

- (void)configureWithMessage:(id)message
{
    NBTheme *theme = [NBTheme sharedTheme];

    if (arc4random() % 2)
    {
        self.messageLabel.textAlignment = NSTextAlignmentRight;
        self.backgroundImageView.backgroundColor = theme.lightGreenColor;
        self.messageLabel.textColor = theme.whiteColor;
        self.imageViewLeadingConstraint.constant = 30.f;
        self.imageViewTrailingConstraint.constant = 10.f;
    }
    else
    {
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
        self.backgroundImageView.backgroundColor = theme.beigeColor;
        self.messageLabel.textColor = theme.darkGrayColor;
        self.imageViewLeadingConstraint.constant = 10.f;
        self.imageViewTrailingConstraint.constant = 30.f;
    }
    
    [self layoutSubviews];
}

#pragma mark - NBTableViewCell

- (void)setHighlighted:(BOOL)highlighted
{ }

@end
