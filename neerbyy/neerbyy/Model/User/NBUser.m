//
//  NBUser.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 01/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBUser.h"
#import "NBUserAvatar.h"
#import "NBDictionaryDecoder.h"


#pragma mark - Constants

static NSString * const kNBUserIdentifierKey = @"id";
static NSString * const kNBUserUsernameKey = @"username";
static NSString * const kNBUserFirstnameKey = @"firstname";
static NSString * const kNBUserLastnameKey = @"lastname";
static NSString * const kNBUserEmailKey = @"email";
static NSString * const kNBUserAvatarKey = @"avatar";

#pragma mark -


@interface NBUser ()

@property (strong, nonatomic) NSDictionary *avatarDictionary;

@end


@implementation NBUser

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.identifier = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBUserIdentifierKey];
        self.username = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBUserUsernameKey];
        self.firstname = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBUserFirstnameKey];
        self.lastname = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBUserLastnameKey];
        self.email = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBUserEmailKey];
        self.avatarDictionary = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBUserAvatarKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:kNBUserIdentifierKey];
    [aCoder encodeObject:self.username forKey:kNBUserUsernameKey];
    [aCoder encodeObject:self.firstname forKey:kNBUserFirstnameKey];
    [aCoder encodeObject:self.lastname forKey:kNBUserLastnameKey];
    [aCoder encodeObject:self.email forKey:kNBUserEmailKey];
    [aCoder encodeObject:self.avatarDictionary forKey:kNBUserAvatarKey];
}

#pragma mark - Properties

- (NBUserAvatar *)avatar
{
    if (!self.avatarDictionary)
        return nil;
    
    NBDictionaryDecoder *avatarDecoder = [NBDictionaryDecoder dictonaryCoderWithData:self.avatarDictionary];
    NBUserAvatar *avatar = [[NBUserAvatar alloc] initWithCoder:avatarDecoder];
    return avatar;
}

@end
