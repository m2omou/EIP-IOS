//
//  NBButton.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 24/01/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBButton.h"
#import "NBTheme.h"


@implementation NBButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        NBTheme *theme = [NBTheme sharedTheme];

        self.titleLabel.font = [theme.font fontWithSize:self.titleLabel.font.pointSize];
        
        [self setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        [self setTitleColors:@[theme.whiteColor,
                               theme.darkWhiteColor,
                               theme.darkGrayColor]
                   forStates:@[@(UIControlStateNormal),
                               @(UIControlStateHighlighted),
                               @(UIControlStateDisabled)]];
        
        self.layer.cornerRadius = self.frame.size.height / 2.f;
    }

    return self;
}

- (void)setTitleColors:(NSArray *)colors forStates:(NSArray *)states
{
    NSAssert(colors.count == states.count, @"Colors and states arrays must have the same number of elements");
    
    [colors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx, BOOL *stop) {
        NSAssert([color isKindOfClass:[UIColor class]], @"Colors must be an array filled with UIColor objects");
        
        NSNumber *stateObject = states[idx];
        NSAssert([stateObject isKindOfClass:[NSNumber class]], @"States must be an array filled with NSNumber object, wrapping UIControlState values");
        
        UIControlState state = [stateObject integerValue];
        
        [self setTitleColor:color forState:state];
    }];
}

@end


@implementation NBPrimaryButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        NBTheme *theme = [NBTheme sharedTheme];

        self.backgroundColor = theme.lightGreenColor;
        self.titleLabel.font = [theme.boldFont fontWithSize:self.titleLabel.font.pointSize];
    }
    
    return self;
}

@end


@implementation NBSecondaryButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        NBTheme *theme = [NBTheme sharedTheme];
        
        self.backgroundColor = theme.beigeColor;
        [self setTitleColors:@[theme.grayColor,
                               theme.darkGrayColor,
                               theme.lightGrayColor]
                   forStates:@[@(UIControlStateNormal),
                               @(UIControlStateHighlighted),
                               @(UIControlStateDisabled)]];
        self.titleLabel.font = [theme.boldFont fontWithSize:self.titleLabel.font.pointSize];
    }
    
    return self;
}


@end


@implementation NBTextButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        NBTheme *theme = [NBTheme sharedTheme];
        
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [theme.font fontWithSize:self.titleLabel.font.pointSize];
    }
    
    return self;
}

@end
