//
//  NBUser.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 01/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBUser.h"
#import "NBDictionaryDecoder.h"
#import "NBSettings.h"
#import "NBPersistanceManager.h"


#pragma mark - Constants

static NSString * const kNBUserKeyIdentifier = @"id";
static NSString * const kNBUserKeyUsername = @"username";
static NSString * const kNBUserKeyFirstname = @"firstname";
static NSString * const kNBUserKeyLastname = @"lastname";
static NSString * const kNBUserKeyEmail = @"email";
static NSString * const kNBUserKeyAvatar = @"avatar";
static NSString * const kNBUserKeyAvatarThumbnail = @"avatar_thumb";
static NSString * const kNBUserKeyToken = @"auth_token";
static NSString * const kNBUserKeySettingsID = @"settings_id";
static NSString * const kNBUSerKeySettings = @"setting";

#pragma mark -

@interface NBUser ()

@property (strong, nonatomic) NSString *avatarURLString;
@property (strong, nonatomic) NSString *avatarThumbnailURLString;
@property (strong, nonatomic) NSDictionary *settingsDictionary;

@end

@implementation NBUser

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.identifier = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBUserKeyIdentifier];
        self.username = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBUserKeyUsername];
        self.firstname = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBUserKeyFirstname];
        self.lastname = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBUserKeyLastname];
        self.email = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBUserKeyEmail];
        self.avatarURLString = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBUserKeyAvatar];
        self.avatarThumbnailURLString = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBUserKeyAvatarThumbnail];
        self.token = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBUserKeyToken];
        self.settingsID = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBUserKeySettingsID];
        self.settingsDictionary = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:kNBUSerKeySettings];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:kNBUserKeyIdentifier];
    [aCoder encodeObject:self.username forKey:kNBUserKeyUsername];
    [aCoder encodeObject:self.firstname forKey:kNBUserKeyFirstname];
    [aCoder encodeObject:self.lastname forKey:kNBUserKeyLastname];
    [aCoder encodeObject:self.email forKey:kNBUserKeyEmail];
    [aCoder encodeObject:self.avatarURLString forKey:kNBUserKeyAvatar];
    [aCoder encodeObject:self.avatarThumbnailURLString forKey:kNBUserKeyAvatarThumbnail];
    [aCoder encodeObject:self.token forKey:kNBUserKeyToken];
    [aCoder encodeObject:self.settingsID forKey:kNBUserKeySettingsID];
    [aCoder encodeObject:self.settingsDictionary forKey:kNBUSerKeySettings];
}

#pragma mark - Properties

- (NSURL *)avatarURL
{
    return [NSURL URLWithString:self.avatarURLString];
}

- (NSURL *)avatarThumbnailURL
{
    if (!self.avatarThumbnailURLString.length)
        return self.avatarURL;
    return [NSURL URLWithString:self.avatarThumbnailURLString];
}

- (NBSettings *)settings
{
    if (!self.settingsDictionary.allKeys.count)
        return nil;
    NBDictionaryDecoder *settingsDecoder = [NBDictionaryDecoder dictonaryCoderWithData:self.settingsDictionary];
    NBSettings *settings = [[NBSettings alloc] initWithCoder:settingsDecoder];
    return settings;
}

- (void)setSettings:(NBSettings *)settings
{
    self.settingsDictionary = [settings toDictionary];
}

#pragma mark - Public methods

- (BOOL)isEqualToUser:(NBUser *)user
{
    return [user.identifier isEqualToNumber:self.identifier];
}

- (NSString *)completeName
{
    if (self.firstname.length && self.lastname.length)
        return [NSString stringWithFormat:@"%@ %@", self.firstname, self.lastname];
    else if (self.firstname.length)
        return self.firstname;
    else if (self.lastname.length)
        return self.lastname;
    else
        return @"";
}

- (BOOL)currentUserCanSendMessage
{
    NBPersistanceManager *persistanceManager = [NBPersistanceManager sharedManager];
    return persistanceManager.isConnected &&
           persistanceManager.currentUser.settings.canBeContactedByOtherUsers &&
           self.settings.canBeContactedByOtherUsers;
}

@end
