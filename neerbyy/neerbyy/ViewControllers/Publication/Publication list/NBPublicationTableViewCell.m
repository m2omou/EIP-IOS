//
//  NBPublicationTableViewCell.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPublicationTableViewCell.h"
#import "NBCircleImageView.h"
#import "NBTheme.h"


@interface NBPublicationTableViewCell ()

@property (strong, nonatomic) IBOutlet NBCircleImageView *thumnailImageView;
@property (strong, nonatomic) IBOutlet NBLabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet NBLabel *userAndLocationLabel;
@end


@implementation NBPublicationTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NBTheme *theme = [NBTheme sharedTheme];
    self.userAndLocationLabel.textColor = theme.lightGreenColor;
}

#pragma mark - Public methods

- (void)configureWithPublication:(id)publication
{
    NSString *imageName = publication[@"img"];
    UIImage *image = [UIImage imageNamed:imageName];
    self.thumnailImageView.image = image;

    self.descriptionLabel.text = publication[@"description"];
    self.userAndLocationLabel.text = publication[@"smallText"];
}

#pragma mark - NBTableViewCell

- (void)setHighlighted:(BOOL)highlighted
{ }

@end
