//
//  NBVote.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 11/05/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

typedef NS_ENUM(NSUInteger, NBVoteValue) {
    kNBVoteValueDownvote = 0,
    kNBVoteValueUpvote   = 1
};

@interface NBVote : NSObject <NSCoding>

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSNumber *publicationId;
@property (strong, nonatomic) NSNumber *userId;
@property (readonly, nonatomic) NBVoteValue value;

@end
