//
//  UIStoryboard+NBAdditions.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "UIStoryboard+NBAdditions.h"


@implementation UIStoryboard (NBAdditions)

+ (UIStoryboard *)mainStoryboard
{
    static NSString * const kNBMainStoryboard = @"iPhoneStoryboard";

    return [UIStoryboard storyboardWithName:kNBMainStoryboard bundle:nil];
}

+ (UIViewController *)loginViewController
{
    static NSString * const kNBLoginViewControllerIdentifier = @"NBLoginNavigationController";
    
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:kNBLoginViewControllerIdentifier];
}

+ (UIViewController *)placeViewController
{
    static NSString * const kNBPlaceViewControllerIdentifier = @"NBPlaceViewController";
    
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:kNBPlaceViewControllerIdentifier];
}

@end
