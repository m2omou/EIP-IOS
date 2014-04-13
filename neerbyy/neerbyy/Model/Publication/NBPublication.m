//
//  NBPublication.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 13/04/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPublication.h"


#pragma mark - Constants

static NSString * const kNBPublicationKeyIdentifier = @"id";
static NSString * const kNBPublicationKeyUserIdentifier = @"user_id";
static NSString * const kNBPublicationKeyPlaceIdentifier = @"place_id";
static NSString * const kNBPublicationKeyDescription = @"content";
static NSString * const kNBPublicationKeyTypeString = @"type";
static NSString * const kNBPublicationKeyContentURLString = @"url";
static NSString * const kNBPublicationKeyThumbnailURLString = @"thumb_url";
static NSString * const kNBPublicationKeyNumberOfComments = @"comments";
static NSString * const kNBPublicationKeyNumberOfLikes = @"like";
static NSString * const kNBPublicationKeyNumberOfDislikes = @"dislike";

static NSString * const kNBPublicationTypeValueImage = @"image";
static NSString * const kNBPublicationTypeValueLink = @"link";

#pragma mark -


@interface NBPublication ()

@property (strong, nonatomic) NSString *typeString;
@property (strong, nonatomic) NSString *contentURLString;
@property (strong, nonatomic) NSString *thumbnailURLString;

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
        self.description = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPublicationKeyDescription];
        self.typeString = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPublicationKeyTypeString];
        self.contentURLString = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPublicationKeyContentURLString];
        self.thumbnailURLString = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPublicationKeyThumbnailURLString];
        self.numberOfComments = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPublicationKeyNumberOfComments];
        self.numberOfLikes = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPublicationKeyNumberOfLikes];
        self.numberOfDislikes = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPublicationKeyNumberOfDislikes];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:kNBPublicationKeyIdentifier];
    [aCoder encodeObject:self.userId forKey:kNBPublicationKeyUserIdentifier];
    [aCoder encodeObject:self.placeId forKey:kNBPublicationKeyPlaceIdentifier];
    [aCoder encodeObject:self.description forKey:kNBPublicationKeyDescription];
    [aCoder encodeObject:self.typeString forKey:kNBPublicationKeyTypeString];
    [aCoder encodeObject:self.contentURLString forKey:kNBPublicationKeyContentURLString];
    [aCoder encodeObject:self.thumbnailURLString forKey:kNBPublicationKeyThumbnailURLString];
    [aCoder encodeObject:self.numberOfComments forKey:kNBPublicationKeyNumberOfComments];
    [aCoder encodeObject:self.numberOfLikes forKey:kNBPublicationKeyNumberOfLikes];
    [aCoder encodeObject:self.numberOfDislikes forKey:kNBPublicationKeyNumberOfDislikes];
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

@end
