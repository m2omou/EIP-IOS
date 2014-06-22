//
//  NBConversation.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBConversation.h"
#import "NBDictionaryDecoder.h"
#import "NBMessage.h"

#pragma mark - Constants

static NSString * const kNBConversationKeyIdentifier = @"id";
static NSString * const kNBConversationKeyLastestMessages = @"messages";
static NSString * const kNBCovnersationKeyRecipient = @"recipient";

#pragma mark -

@interface NBConversation ()

@property (strong, nonatomic) NSArray *lastestMessagesArray;
@property (strong, nonatomic) NSDictionary *recipientDictionary;
@property (strong, nonatomic) NSMutableArray *convertedLatestsMessages;

@end

@implementation NBConversation

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.identifier = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBConversationKeyIdentifier];
        self.lastestMessagesArray = [aDecoder decodeObjectOfClass:[NSArray class] forKey:kNBConversationKeyLastestMessages];
        self.recipientDictionary = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:kNBCovnersationKeyRecipient];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:kNBConversationKeyIdentifier];
    [aCoder encodeObject:self.lastestMessagesArray forKey:kNBConversationKeyLastestMessages];
    [aCoder encodeObject:self.recipientDictionary forKey:kNBCovnersationKeyRecipient];
}

#pragma mark - Properties

- (NSArray *)latestMessages
{
    if (self.convertedLatestsMessages)
        return [self.convertedLatestsMessages copy];
    
    if (self.lastestMessagesArray.count == 0)
        return nil;
    
    NSMutableArray *messages = [NSMutableArray array];
    for (NSDictionary *rawMessage in self.lastestMessagesArray)
    {
        NBDictionaryDecoder *messageDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawMessage];
        NBMessage *message = [[NBMessage alloc] initWithCoder:messageDecoder];
        [messages addObject:message];
    }
    
    self.convertedLatestsMessages = messages;
    return self.latestMessages;
}

- (NBUser *)recipient
{
    if (self.recipientDictionary.allKeys.count == 0)
        return nil;
    
    NBDictionaryDecoder *userDecoder = [NBDictionaryDecoder dictonaryCoderWithData:self.recipientDictionary];
    NBUser *user = [[NBUser alloc] initWithCoder:userDecoder];
    return user;
}

#pragma mark - Public methods

- (void)addMessage:(NBMessage *)message
{
    [self.convertedLatestsMessages addObject:message];
}

@end
