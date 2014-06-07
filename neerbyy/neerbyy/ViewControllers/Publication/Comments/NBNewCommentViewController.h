//
//  NBNewCommentViewController.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 20/05/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBGenericFormViewController.h"
#import "NBPublication.h"

@class NBNewCommentViewController;

@protocol NBNewCommentViewControllerDelegate <NSObject>

@optional
- (void)newCommentViewController:(NBNewCommentViewController *)newCommentViewController didPublishComment:(NBComment *)comment;
- (void)newCommentViewControllerDidDismiss:(NBNewCommentViewController *)newCommentViewController;

@end

@interface NBNewCommentViewController : NBGenericFormViewController

@property (strong, nonatomic) NBPublication *publication;
@property (weak, nonatomic) id<NBNewCommentViewControllerDelegate> delegate;

@end
