//
//  UITextField+Required.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 01/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "UITextField+Required.h"


@implementation UITextField (Required)

- (BOOL)isRequired
{
    return self.enablesReturnKeyAutomatically;
}

- (void)setIsRequired:(BOOL)isRequired
{
    self.enablesReturnKeyAutomatically = isRequired;
}

- (BOOL)canReturn
{
    NSUInteger textLength = self.text.length;
    BOOL hasText = textLength > 0;
    BOOL isRequired = self.isRequired;

    if (isRequired == NO || hasText == YES)
        return YES;
    else
        return NO;
}

@end
