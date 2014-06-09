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
#import "NBPlace.h"

#pragma mark - Constants

static NSString * const kNBPublicationKeyIdentifier = @"id";
static NSString * const kNBPublicationKeyContentDescription = @"content";
static NSString * const kNBPublicationKeyLongitude = @"longitude";
static NSString * const kNBPublicationKeyLatitude = @"latitude";
static NSString * const kNBPublicationKeyTypeString = @"type";
static NSString * const kNBPublicationKeyContentURL = @"url";
static NSString * const kNBPublicationKeyThumbnailURL = @"thumb_url";
static NSString * const kNBPublicationKeyNumberOfComments = @"comments";
static NSString * const kNBPublicationKeyNumberOfUpvotes = @"upvotes";
static NSString * const kNBPublicationKeyNumberOfDownvotes = @"downvotes";
static NSString * const kNBPublicationKeyVoteOfCurrentUser = @"vote";
static NSString * const kNBPublicationKeyAuthor = @"user";
static NSString * const kNBPublicationKeyPlace = @"place";

#pragma mark -


@interface NBPublication ()

@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat latitude;
@property (strong, nonatomic) NSNumber *typeNumber;
@property (strong, nonatomic) NSString *contentURLString;
@property (strong, nonatomic) NSString *thumbnailURLString;
@property (strong, nonatomic) NSDictionary *voteOfCurrentUserDictionary;
@property (strong, nonatomic) NSDictionary *authorDictionary;
@property (strong, nonatomic) NSDictionary *placeDictionary;

@end


@implementation NBPublication

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.identifier = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPublicationKeyIdentifier];
        self.longitude = [aDecoder decodeFloatForKey:kNBPublicationKeyLongitude];
        self.latitude = [aDecoder decodeFloatForKey:kNBPublicationKeyLatitude];
        self.typeNumber = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPublicationKeyTypeString];
        self.contentDescription = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPublicationKeyContentDescription];
        self.contentURLString = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPublicationKeyContentURL];
        self.thumbnailURLString = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPublicationKeyThumbnailURL];
        self.numberOfComments = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPublicationKeyNumberOfComments];
        self.numberOfUpvotes = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPublicationKeyNumberOfUpvotes];
        self.numberOfDownvotes = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPublicationKeyNumberOfDownvotes];
        self.voteOfCurrentUserDictionary = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:kNBPublicationKeyVoteOfCurrentUser];
        self.authorDictionary = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:kNBPublicationKeyAuthor];
        self.placeDictionary = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:kNBPublicationKeyPlace];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:kNBPublicationKeyIdentifier];
    [aCoder encodeFloat:self.longitude forKey:kNBPublicationKeyLongitude];
    [aCoder encodeFloat:self.latitude forKey:kNBPublicationKeyLatitude];
    [aCoder encodeObject:self.typeNumber forKey:kNBPublicationKeyTypeString];
    [aCoder encodeObject:self.contentDescription forKey:kNBPublicationKeyContentDescription];
    [aCoder encodeObject:self.contentURLString forKey:kNBPublicationKeyContentURL];
    [aCoder encodeObject:self.thumbnailURLString forKey:kNBPublicationKeyThumbnailURL];
    [aCoder encodeObject:self.numberOfComments forKey:kNBPublicationKeyNumberOfComments];
    [aCoder encodeObject:self.numberOfUpvotes forKey:kNBPublicationKeyNumberOfUpvotes];
    [aCoder encodeObject:self.numberOfDownvotes forKey:kNBPublicationKeyNumberOfDownvotes];
    [aCoder encodeObject:self.voteOfCurrentUserDictionary forKey:kNBPublicationKeyVoteOfCurrentUser];
    [aCoder encodeObject:self.authorDictionary forKey:kNBPublicationKeyAuthor];
    [aCoder encodeObject:self.placeDictionary forKey:kNBPublicationKeyPlace];
}

#pragma mark - Properties

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    return coordinate;
}

- (NBPublicationType)type
{
    NSUInteger typeValue = self.typeNumber.integerValue;
    
    if (typeValue > kNBPublicationTypeUnknown)
        return kNBPublicationTypeUnknown;
    return (NBPublicationType)typeValue;
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
    
    NBDictionaryDecoder *userDecoder = [NBDictionaryDecoder dictonaryCoderWithData:self.authorDictionary];
    return [[NBUser alloc] initWithCoder:userDecoder];
}

- (NBPlace *)place
{
    if (!self.placeDictionary.allKeys.count)
        return nil;
    
    NBDictionaryDecoder *placeDecoder = [NBDictionaryDecoder dictonaryCoderWithData:self.placeDictionary];
    return [[NBPlace alloc] initWithCoder:placeDecoder];
}

#pragma mark - Public methods

- (BOOL)isFromUser:(NBUser *)user
{
    return [self.author isEqualToUser:user];
}

@end
