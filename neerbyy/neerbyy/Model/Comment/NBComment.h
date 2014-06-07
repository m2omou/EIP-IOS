//
//  NBComment.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 11/05/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

@class NBUser;

@interface NBComment : NSObject <NSCoding>

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *content;
@property (readonly, nonatomic) NBUser *author;

- (BOOL)isFromUser:(NBUser *)user;

@end
