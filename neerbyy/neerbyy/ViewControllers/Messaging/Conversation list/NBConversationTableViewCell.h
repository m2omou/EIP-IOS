//
//  NBConversationTableViewCell.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBTableViewCell.h"
#import "NBConversation.h"
#import "NBMessage.h"

@interface NBConversationTableViewCell : NBTableViewCell

- (void)configureWithConversation:(NBConversation *)conversation;

@end
