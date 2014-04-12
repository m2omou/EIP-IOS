//
//  NBBlurredZoomedImageView.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/03/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import "NBBlurredZoomedImageView.h"
#import "UIImage+Blur.h"


#pragma mark - Constants

static CGFloat const kNBBlurredZoomedImageViewDefaultBlur = 20.f;

#pragma mark -


@interface NBBlurredZoomedImageView ()

@property (strong, nonatomic) UIImage *originalImage;

@end


@implementation NBBlurredZoomedImageView

- (void)layoutSubviews
{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.blurRadius = kNBBlurredZoomedImageViewDefaultBlur;
}

- (void)setBlurRadius:(CGFloat)blurRadius
{
    if (_blurRadius != blurRadius)
    {
        _blurRadius = blurRadius;
        self.image = (self.originalImage ?: self.image); /* Triggers the blurring method */
    }
}

- (void)setImage:(UIImage *)image
{
    self.originalImage = image;

    UIImage *blurredImage = [image blurredImageWithRadius:self.blurRadius];
    [super setImage:blurredImage];
}

@end
