//
//  NBVote.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 11/05/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBVote.h"

#pragma mark - Constants

static NSString * const kNBVoteKeyIdentifier = @"id";
static NSString * const kNBVoteKeyPublicationId = @"publication_id";
static NSString * const kNBVoteKeyUserId = @"user_id";
static NSString * const kNBVoteKeyValueString = @"value";

#pragma mark -

@interface NBVote ()

@property (strong, nonatomic) NSString *valueNumber;

@end

@implementation NBVote

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.identifier = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBVoteKeyIdentifier];
        self.publicationId = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBVoteKeyPublicationId];
        self.userId = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBVoteKeyUserId];
        self.valueNumber = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBVoteKeyValueString];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:kNBVoteKeyIdentifier];
    [aCoder encodeObject:self.publicationId forKey:kNBVoteKeyPublicationId];
    [aCoder encodeObject:self.userId forKey:kNBVoteKeyUserId];
    [aCoder encodeObject:self.valueNumber forKey:kNBVoteKeyValueString];
}

#pragma mark - Properties

- (NBVoteValue)value
{
    if (self.valueNumber.boolValue == YES)
        return kNBVoteValueLike;
    else
        return kNBVoteValueDislike;
}

@end
