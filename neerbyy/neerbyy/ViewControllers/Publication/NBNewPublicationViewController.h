//
//  NBNewPublicationViewController.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 06/04/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBGenericFormViewController.h"
#import "NBPlace.h"

@class NBNewPublicationViewController;

@protocol NBNewPublicationViewControllerDelegate <NSObject>

@optional
- (void)newPublicationViewController:(NBNewPublicationViewController *)newPublicationViewController didPublishPublication:(NBPublication *)publication;
- (void)newPublicationViewControllerDidDismiss:(NBNewPublicationViewController *)newPublicationViewController;

@end


@interface NBNewPublicationViewController : NBGenericFormViewController

@property (strong, nonatomic) NBPlace *place;
@property (weak, nonatomic) id<NBNewPublicationViewControllerDelegate> delegate;

@end
