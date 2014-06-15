//
//  NBAppDelegate.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 12/11/2013.
//  Copyright (c) 2013 neerbyy. All rights reserved.
//

@interface NBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)showLoginAlertViewWithViewController:(UIViewController *)viewController completion:(void(^)())completion;

@end
