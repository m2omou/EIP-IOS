//
//  NBConversationViewController.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBGenericViewController.h"
#import "NBConversation.h"

@class NBConversationViewController;

@protocol NBConversationViewControllerDelegate <NSObject>

@optional
- (void)conversationViewController:(NBConversationViewController *)conversationViewController latestMessageDidChange:(NBMessage *)message;

@end


@interface NBConversationViewController : NBGenericViewController

@property (strong, nonatomic) NBConversation *conversation;
@property (weak, nonatomic) id<NBConversationViewControllerDelegate> delegate;

@end
