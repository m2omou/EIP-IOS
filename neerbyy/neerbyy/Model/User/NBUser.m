//
//  NBUser.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 01/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBUser.h"


@implementation NBUser

#pragma mark - NSKeyValueCoding

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:kNBAPIUserIDKey])
        self.identifier = [self data:value ofType:[NSNumber class]];
    else if ([key isEqualToString:kNBAPIUserUsernameKey])
        self.username = [self data:value ofType:[NSString class]];
    else if ([key isEqualToString:kNBAPIUserFirsnameKey])
        self.firstname = [self data:value ofType:[NSString class]];
    else if ([key isEqualToString:kNBAPIUserLastnameKey])
        self.lastname = [self data:value ofType:[NSString class]];
    else if ([key isEqualToString:kNBAPIUserEmailKey])
        self.email = [self data:value ofType:[NSString class]];
    else if ([key isEqualToString:kNBAPIUserPasswordKey])
        self.password = [self data:value ofType:[NSString class]];
    else if ([key isEqualToString:kNBAPIUserAvatarKey])
        self.avatarURL = [self data:value ofType:[NSString class]];
}

#pragma mark - NBAbstractModel

- (NSDictionary *)dictionaryWithModel
{
    return @{kNBAPIUserIDKey:       NilToEmpty(self.identifier, NSString),
             kNBAPIUserUsernameKey: NilToEmpty(self.username, NSString),
             kNBAPIUserFirsnameKey: NilToEmpty(self.firstname, NSString),
             kNBAPIUserLastnameKey: NilToEmpty(self.lastname, NSString),
             kNBAPIUserEmailKey:    NilToEmpty(self.email, NSString),
             kNBAPIUserPasswordKey: NilToEmpty(self.password, NSString),
             kNBAPIUserAvatarKey:   NilToEmpty(self.avatarURL, NSString)
             };
}

@end
