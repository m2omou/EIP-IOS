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
#import "NBUser.h"

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

- (void)configureWithPublication:(NBPublication *)publication displayPlace:(BOOL)displayPlace
{
    [self configureImageViewWithPublication:publication];

    self.descriptionLabel.text = publication.contentDescription;
    
    if (displayPlace == NO)
        self.userAndLocationLabel.text = publication.author.username;
    else /* TODO : Get the place name from the API */
        self.userAndLocationLabel.text = [NSString stringWithFormat:@"%@ @ %@", publication.author.username, publication.placeId];
}

- (void)configureImageViewWithPublication:(NBPublication *)publication
{
    switch (publication.type) {
        case kNBPublicationTypeText:
        case kNBPublicationTypeUnknown:
            self.thumnailImageView.image = [UIImage imageNamed:@"img-txt"];
            break;

        case kNBPublicationTypeImage:
            [self.thumnailImageView setImageFromURL:publication.thumbnailURL placeHolderImage:[UIImage imageNamed:@"img-img"]];
            break;
        
        case kNBPublicationTypeLink:
            self.thumnailImageView.image = [UIImage imageNamed:@"img-web"];
            break;
        
        case kNBPublicationTypeYoutube:
            self.thumnailImageView.image = [UIImage imageNamed:@"img-youtube"];
            break;

        case kNBPublicationTypeFile:
            self.thumnailImageView.image = [UIImage imageNamed:@"img-file"];
            break;
    }
}

#pragma mark - NBTableViewCell

- (void)setHighlighted:(BOOL)highlighted
{ }

@end
