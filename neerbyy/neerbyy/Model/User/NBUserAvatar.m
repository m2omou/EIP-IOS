//
//  NBUserAvatar.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 13/04/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBUserAvatar.h"


#pragma mark - Constants

static NSString * const kNBUserAvatarStringKey = @"url";
static NSString * const kNBUserAvatarThumbnailDictionaryKey = @"thumb";
static NSString * const kNBUserAvatarThumbnailStringKey = @"url";

#pragma mark -


@interface NBUserAvatar ()

@property (strong, nonatomic) NSString *avatarString;
@property (strong, nonatomic) NSDictionary *thumbnailDictionary;

@end


@implementation NBUserAvatar

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.avatarString = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBUserAvatarStringKey];
        self.thumbnailDictionary = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:kNBUserAvatarThumbnailDictionaryKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.avatarString forKey:kNBUserAvatarStringKey];
    [aCoder encodeObject:self.thumbnailDictionary forKey:kNBUserAvatarThumbnailDictionaryKey];
}

#pragma mark - Properties

- (NSURL *)avatarURL
{
    NSURL *url = [NSURL URLWithString:self.avatarString];
    return url;
}

- (NSURL *)thumbnailURL
{
    NSString *avatarString = self.thumbnailDictionary[kNBUserAvatarThumbnailStringKey];
    NSURL *url = [NSURL URLWithString:avatarString];
    return url;
}

@end
