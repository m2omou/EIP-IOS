//
//  NBMessage.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBMessage.h"
#import "NBDictionaryDecoder.h"
#import "NBPersistanceManager.h"

#pragma mark - Constants

static NSString * const kNBMessageKeyIdentifier = @"id";
static NSString * const kNBMessageKeyContent = @"content";
static NSString * const kNBMessageKeyAuthor = @"sender";
static NSString * const kNBMessageKeyDate = @"created_at";

#pragma mark -

@interface NBMessage ()

@property (strong, nonatomic) NSDictionary *authorDictionary;
@property (strong, nonatomic) NSString *dateTimeString;

@end

@implementation NBMessage

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.identifier = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBMessageKeyIdentifier];
        self.content = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBMessageKeyContent];
        self.authorDictionary = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:kNBMessageKeyAuthor];
        self.dateTimeString = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBMessageKeyDate];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:kNBMessageKeyIdentifier];
    [aCoder encodeObject:self.content forKey:kNBMessageKeyContent];
    [aCoder encodeObject:self.authorDictionary forKey:kNBMessageKeyAuthor];
    [aCoder encodeObject:self.dateTimeString forKey:kNBMessageKeyDate];
}

#pragma mark - Properties

- (NBUser *)author
{
    NBDictionaryDecoder *authorDecoder = [NBDictionaryDecoder dictonaryCoderWithData:self.authorDictionary];
    NBUser *user = [[NBUser alloc] initWithCoder:authorDecoder];
    return user;
}

- (NSDate *)dateTime
{
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    dateFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    return [dateFormat dateFromString:self.dateTimeString];
}

- (BOOL)isFromCurrentUser
{
    NBPersistanceManager *persistanceManager = [NBPersistanceManager sharedManager];
    if (persistanceManager.isConnected == NO)
        return NO;
    
    NBUser *currentUser = persistanceManager.currentUser;
    BOOL isSameUser = [self.author isEqualToUser:currentUser];
    return isSameUser;
}

@end
