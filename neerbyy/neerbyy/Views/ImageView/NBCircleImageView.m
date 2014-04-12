//
//  NBCircleImageView.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/03/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import "NBCircleImageView.h"


@implementation NBCircleImageView

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize size = self.bounds.size;
    NSAssert(size.height == size.width, @"NBCircleImageView requires to have the same height and width");
    
    CGFloat cornerRadius = size.height / 2.f;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

@end
