//
//  UINavigationController+NBAdditions.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 12/04/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

@interface UINavigationController (NBAdditions)

- (UIViewController *)previousViewController;
- (id)previousViewControllerOfClass:(Class)class;

@end
