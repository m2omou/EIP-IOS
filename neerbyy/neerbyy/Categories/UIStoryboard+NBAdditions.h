//
//  UIStoryboard+NBAdditions.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

@class NBTutorialViewController;
@class NBPlaceListViewController;
@class NBPlaceViewController;
@class NBReportViewController;

@interface UIStoryboard (NBAdditions)

+ (UIStoryboard *)mainStoryboard;
+ (UINavigationController *)loginViewController;
+ (NBTutorialViewController *)tutorialViewController;
+ (NBPlaceViewController *)placeViewController;
+ (NBPlaceListViewController *)placeListViewController;
+ (NBReportViewController *)reportViewController;

@end
