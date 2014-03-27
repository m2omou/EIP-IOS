//
//  NBTheme.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 24/01/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBTheme.h"

@implementation NBTheme

#pragma mark - Public methods

+ (instancetype)sharedTheme
{
    static id sharedTheme;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTheme = [[self class] new];
        
    });
    return sharedTheme;
}

#pragma mark - Properties - Fonts

- (UIFont *)font
{
    return [UIFont fontWithName:@"GothamRounded-Book" size:15.f];
}

- (UIFont *)boldFont
{
    return [UIFont fontWithName:@"GothamRounded-Medium" size:15.f];
}

- (UIFont *)lightFont
{
    return [UIFont fontWithName:@"GothamRounded-Light" size:15.f];
}

#pragma mark - Properties - Colors

- (UIColor *)orangeColor
{
    return [self colorWithBitOfRed:255 green:64 blue:0];
}

- (UIColor *)beigeColor
{
    return [self colorWithBitOfRed:228 green:212 blue:150];
}

- (UIColor *)lightGreenColor
{
    return [self colorWithBitOfRed:0 green:193 blue:144];
}

- (UIColor *)lightGrayColor
{
    return [self colorWithBitOfRed:220 green:220 blue:220];
}

- (UIColor *)grayColor
{
    return [self colorWithBitOfRed:120 green:120 blue:120];
}

- (UIColor *)darkGrayColor
{
    return [self colorWithBitOfRed:75 green:75 blue:75];
}

- (UIColor *)darkWhiteColor
{
    return [self colorWithBitOfRed:240 green:240 blue:240];
}

- (UIColor *)whiteColor
{
    return [UIColor whiteColor];
}

#pragma mark - Private methods

- (UIColor *)colorWithBitOfRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

- (UIColor *)colorWithBitOfRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue
{
    return [self colorWithBitOfRed:red green:green blue:blue alpha:1.f];
}

@end
