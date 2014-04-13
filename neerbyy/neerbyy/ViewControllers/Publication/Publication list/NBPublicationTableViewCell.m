//
//  NBPublicationTableViewCell.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPublicationTableViewCell.h"
#import <UIImageView+MKNetworkKitAdditions.h>
#import "NBCircleImageView.h"
#import "NBPublication.h"
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

- (void)configureWithPublication:(NBPublication *)publication
{
    [self.thumnailImageView setImageFromURL:publication.thumbnailURL];
    self.descriptionLabel.text = publication.description;
    self.userAndLocationLabel.text = [NSString stringWithFormat:@"%@ @ %@", publication.userId, publication.placeId];
}

#pragma mark - NBTableViewCell

- (void)setHighlighted:(BOOL)highlighted
{ }

@end
