//
//  UIImage+Blur.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/03/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import "UIImage+Blur.h"

@implementation UIImage (Blur)

- (UIImage *)blurredImageWithRadius:(CGFloat)radius
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(radius) forKey:@"inputRadius"];

    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];

    return [UIImage imageWithCGImage:cgImage];
}

@end
