//
//  NBConversation.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBUser.h"

@interface NBConversation : NSObject <NSCoding>

@property (strong, nonatomic) NSNumber *identifier;
@property (readonly, nonatomic) NSArray *latestMessages;
@property (readonly, nonatomic) NBUser *recipient;

@end
