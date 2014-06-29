//
//  NBSettings.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 26/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBSettings.h"

#pragma mark - Constants

static NSString * const kNBSettingsKeyIdentifier = @"identifier";
static NSString * const kNBSettingsKeyAllowMessages = @"allow_messages";
static NSString * const kNBSettingsKeyNotificationOnComments = @"send_notification_for_comments";
static NSString * const kNBSettingsKeyNotificationOnMessages = @"send_notification_for_messages";

#pragma mark -

@implementation NBSettings

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.identifier = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBSettingsKeyIdentifier];
        self.canBeContactedByOtherUsers = [aDecoder decodeBoolForKey:kNBSettingsKeyAllowMessages];
        self.receivesNotificationOnComments = [aDecoder decodeBoolForKey:kNBSettingsKeyNotificationOnComments];
        self.receivesNotificationOnMessages = [aDecoder decodeBoolForKey:kNBSettingsKeyNotificationOnMessages];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:kNBSettingsKeyIdentifier];
    [aCoder encodeBool:self.canBeContactedByOtherUsers forKey:kNBSettingsKeyAllowMessages];
    [aCoder encodeBool:self.receivesNotificationOnComments forKey:kNBSettingsKeyNotificationOnComments];
    [aCoder encodeBool:self.receivesNotificationOnComments forKey:kNBSettingsKeyNotificationOnMessages];
}

- (NSDictionary *)toDictionary
{
    return @{kNBSettingsKeyIdentifier: self.identifier,
             kNBSettingsKeyAllowMessages:@(self.canBeContactedByOtherUsers),
             kNBSettingsKeyNotificationOnComments:@(self.receivesNotificationOnComments),
             kNBSettingsKeyNotificationOnMessages:@(self.receivesNotificationOnMessages)};
}

@end
