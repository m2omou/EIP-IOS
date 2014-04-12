//
//  UINavigationController+NBAdditions.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 12/04/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "UINavigationController+NBAdditions.h"

@implementation UINavigationController (NBAdditions)

- (UIViewController *)previousViewController
{
    NSInteger numberOfViewControllers = self.viewControllers.count;
    NSInteger indexOfPreviousViewController = numberOfViewControllers - 2;
    
    if (indexOfPreviousViewController < 0)
        return nil;
    else
        return self.viewControllers[indexOfPreviousViewController];
}

- (id)previousViewControllerOfClass:(Class)class
{
    UIViewController *previousViewController = [self previousViewController];

    if (![previousViewController isKindOfClass:class])
        return nil;
    else
        return previousViewController;
}

@end
