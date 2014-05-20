//
//  NBPublication.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 13/04/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPublication.h"
#import "NBDictionaryDecoder.h"
#import "NBVote.h"
#import "NBUser.h"

//@property (strong, nonatomic) NSNumber *identifier;
//@property (strong, nonatomic) NSNumber *userId;
//@property (strong, nonatomic) NSNumber *placeId;
//@property (readonly, nonatomic) NBPublicationType type;
//@property (strong, nonatomic) NSString *contentDescription;
//@property (readonly, nonatomic) NSURL *contentURL;
//@property (readonly, nonatomic) NSURL *thumbnailURL;
//@property (strong, nonatomic) NSNumber *numberOfComments;
//@property (strong, nonatomic) NSNumber *numberOfLikes;
//@property (strong, nonatomic) NSNumber *numberOfDislikes;
//@property (strong, nonatomic) NBVote *voteOfCurrentUser;
//@property (strong, nonatomic) NBUser *author;

#pragma mark - Constants

static NSString * const kNBPublicationKeyIdentifier = @"id";
static NSString * const kNBPublicationKeyUserIdentifier = @"user_id";
static NSString * const kNBPublicationKeyPlaceIdentifier = @"place_id";
static NSString * const kNBPublicationKeyContentDescription = @"content";
static NSString * const kNBPublicationKeyTypeString = @"type";
static NSString * const kNBPublicationKeyContentURL = @"url";
static NSString * const kNBPublicationKeyThumbnailURL = @"thumb_url";
static NSString * const kNBPublicationKeyNumberOfComments = @"comments";
static NSString * const kNBPublicationKeyNumberOfLikes = @"like";
static NSString * const kNBPublicationKeyNumberOfDislikes = @"dislike";
static NSString * const kNBPublicationKeyVoteOfCurrentUser = @"vote";
static NSString * const kNBPublicationKeyAuthor = @"user";

static NSString * const kNBPublicationTypeValueImage = @"image";
static NSString * const kNBPublicationTypeValueLink = @"link";

#pragma mark -


@interface NBPublication ()

@property (strong, nonatomic) NSString *typeString;
@property (strong, nonatomic) NSString *contentURLString;
@property (strong, nonatomic) NSString *thumbnailURLString;
@property (strong, nonatomic) NSDictionary *voteOfCurrentUserDictionary;
@property (strong, nonatomic) NSDictionary *authorDictionary;

@end


@implementation NBPublication

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.identifier = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPublicationKeyIdentifier];
        self.userId = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPublicationKeyUserIdentifier];
        self.placeId = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPublicationKeyPlaceIdentifier];
        self.contentDescription = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPublicationKeyContentDescription];
        self.typeString = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPublicationKeyTypeString];
        self.contentURLString = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPublicationKeyContentURL];
        self.thumbnailURLString = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPublicationKeyThumbnailURL];
        self.numberOfComments = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPublicationKeyNumberOfComments];
        self.numberOfLikes = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPublicationKeyNumberOfLikes];
        self.numberOfDislikes = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPublicationKeyNumberOfDislikes];
        self.voteOfCurrentUserDictionary = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:kNBPublicationKeyVoteOfCurrentUser];
        self.authorDictionary = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:kNBPublicationKeyAuthor];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:kNBPublicationKeyIdentifier];
    [aCoder encodeObject:self.userId forKey:kNBPublicationKeyUserIdentifier];
    [aCoder encodeObject:self.placeId forKey:kNBPublicationKeyPlaceIdentifier];
    [aCoder encodeObject:self.contentDescription forKey:kNBPublicationKeyContentDescription];
    [aCoder encodeObject:self.typeString forKey:kNBPublicationKeyTypeString];
    [aCoder encodeObject:self.contentURLString forKey:kNBPublicationKeyContentURL];
    [aCoder encodeObject:self.thumbnailURLString forKey:kNBPublicationKeyThumbnailURL];
    [aCoder encodeObject:self.numberOfComments forKey:kNBPublicationKeyNumberOfComments];
    [aCoder encodeObject:self.numberOfLikes forKey:kNBPublicationKeyNumberOfLikes];
    [aCoder encodeObject:self.numberOfDislikes forKey:kNBPublicationKeyNumberOfDislikes];
    [aCoder encodeObject:self.voteOfCurrentUserDictionary forKey:kNBPublicationKeyVoteOfCurrentUser];
    [aCoder encodeObject:self.authorDictionary forKey:kNBPublicationKeyAuthor];
}

#pragma mark - Properties

- (NBPublicationType)type
{
    if ([self.typeString isEqualToString:kNBPublicationTypeValueImage])
        return kNBPublicationTypeImage;
    else if ([self.typeString isEqualToString:kNBPublicationTypeValueLink])
        return kNBPublicationTypeLink;
    else
        return kNBPublicationTypeUnknown;
}

- (NSURL *)contentURL
{
    if (!self.contentURLString)
        return nil;
    
    NSURL *url = [NSURL URLWithString:self.contentURLString];
    return url;
}

- (NSURL *)thumbnailURL
{
    if (!self.thumbnailURLString)
        return self.contentURL;
    
    NSURL *url = [NSURL URLWithString:self.thumbnailURLString];
    return url;
}

@synthesize voteOfCurrentUser = _voteOfCurrentUser;
- (NBVote *)voteOfCurrentUser
{
    if (_voteOfCurrentUser == nil)
    {
        if (!self.voteOfCurrentUserDictionary.allKeys.count)
            return nil;

        NBDictionaryDecoder *voteDecoder = [NBDictionaryDecoder dictonaryCoderWithData:self.voteOfCurrentUserDictionary];
        _voteOfCurrentUser = [[NBVote alloc] initWithCoder:voteDecoder];
    }
    
    return _voteOfCurrentUser;
}

- (void)setVoteOfCurrentUser:(NBVote *)voteOfCurrentUser
{
    if (voteOfCurrentUser == nil)
    {
        self.voteOfCurrentUserDictionary = nil;
    }
    _voteOfCurrentUser = voteOfCurrentUser;
}

- (NBUser *)author
{
    if (!self.authorDictionary.allKeys.count)
        return nil;
    
    NBDictionaryDecoder *userDecoder = [NBDictionaryDecoder dictonaryCoderWithData:self.voteOfCurrentUserDictionary];
    return [[NBUser alloc] initWithCoder:userDecoder];
}

@end
