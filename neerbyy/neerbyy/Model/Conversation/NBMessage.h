//
//  NBMessage.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBUser.h"

@interface NBMessage : NSObject <NSCoding>

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *content;
@property (readonly, nonatomic) NBUser *author;
@property (readonly, nonatomic) NSDate *dateTime;

- (BOOL)isFromCurrentUser;

@end
