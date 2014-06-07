//
//  NBPlaceTableViewCell.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPlaceTableViewCell.h"
#import "NBCircleImageView.h"
#import "NBTheme.h"
#import <UIImageView+MKNetworkKitAdditions.h>

@interface NBPlaceTableViewCell ()

@property (strong, nonatomic) IBOutlet NBCircleImageView *previewImageView;
@property (strong, nonatomic) IBOutlet NBLabel *nameLabel;
@property (strong, nonatomic) IBOutlet NBBoldLabel *publicationsCountLabel;
@property (strong, nonatomic) IBOutlet NBBoldLabel *positionLabel;

@end


@implementation NBPlaceTableViewCell

#pragma mark - NBTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.previewImageView.backgroundColor = [NBTheme sharedTheme].lightGreenColor;
}

#pragma mark - Public methods

- (void)configureWithPlace:(NBPlace *)place
{
    [self.previewImageView setImageFromURL:[NSURL URLWithString:place.iconURL]];
    self.nameLabel.text = place.name;
    self.publicationsCountLabel.text = @"";
    self.positionLabel.text = place.city;
}

#pragma mark - NBTableViewCell

- (void)setHighlighted:(BOOL)highlighted
{ }

@end
