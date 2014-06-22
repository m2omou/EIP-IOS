//
//  NBNewMessageViewController.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBGenericFormViewController.h"
#import "NBConversation.h"
#import "NBMessage.h"
#import "NBUser.h"

@class NBNewMessageViewController;

@protocol NBNewMessageViewControllerDelegate <NSObject>

@optional
- (void)newMessageViewController:(NBNewMessageViewController *)newMessageViewController didSendMessage:(NBMessage *)message creatingConversation:(NBConversation *)conversation;
- (void)newMessageViewControllerDidDismiss:(NBNewMessageViewController *)newMessageViewController;

@end


@interface NBNewMessageViewController : NBGenericFormViewController

@property (strong, nonatomic) NBUser *recipient;
@property (weak, nonatomic) id<NBNewMessageViewControllerDelegate> delegate;

@end
