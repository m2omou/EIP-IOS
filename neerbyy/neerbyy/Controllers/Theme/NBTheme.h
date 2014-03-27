//
//  NBTheme.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 24/01/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

@interface NBTheme : NSObject

+ (instancetype)sharedTheme;

@property (readonly, nonatomic) UIFont *font;
@property (readonly, nonatomic) UIFont *boldFont;
@property (readonly, nonatomic) UIFont *lightFont;

@property (readonly, nonatomic) UIColor *orangeColor;
@property (readonly, nonatomic) UIColor *beigeColor;
@property (readonly, nonatomic) UIColor *lightGreenColor;
@property (readonly, nonatomic) UIColor *lightGrayColor;
@property (readonly, nonatomic) UIColor *grayColor;
@property (readonly, nonatomic) UIColor *darkGrayColor;
@property (readonly, nonatomic) UIColor *darkWhiteColor;
@property (readonly, nonatomic) UIColor *whiteColor;

@end
