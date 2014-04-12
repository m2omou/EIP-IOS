//
//  NBLabel.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 21/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBLabel.h"
#import "NBTheme.h"


@implementation NBLabel

- (id)initWithFontSize:(CGFloat)fontSize
{
    self = [super init];
    
    if (self)
    {
        self.font = [self.font fontWithSize:fontSize];
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    NBTheme *theme = [NBTheme sharedTheme];
    
    self.font = [theme.font fontWithSize:self.font.pointSize];
}

@end


@implementation NBBoldLabel

- (void)commonInit
{
    NBTheme *theme = [NBTheme sharedTheme];
    
    self.font = [theme.boldFont fontWithSize:self.font.pointSize];
}

@end
