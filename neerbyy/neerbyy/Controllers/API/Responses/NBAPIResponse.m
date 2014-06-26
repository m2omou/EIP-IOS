//
//  NBAPIResponse.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import "NBAPIResponse.h"
#import "NBDictionaryDecoder.h"
#import "NBReportPublication.h"
#import "NBPublication.h"
#import "NBPlace.h"
#import "NBUser.h"
#import "NBVote.h"
#import "NBComment.h"
#import "NBReportComment.h"
#import "NBConversation.h"
#import "NBMessage.h"
#import "NBConversation.h"
#import "NBPlaceCategory.h"

#pragma mark - Constants

static NSString * const kNBAPIResponseKeyCode = @"responseCode";
static NSString * const kNBAPIResponseKeyMessage = @"responseMessage";
static NSString * const kNBAPIResponseKeyResult = @"result";

static NSString * const kNBAPIResponseKeyUser = @"user";
static NSString * const kNBAPIResponseKeyPublication = @"publication";
static NSString * const kNBAPIResponseKeyPlace = @"place";
static NSString * const kNBAPIResponseKeyPlaceList = @"places";
static NSString * const kNBAPIResponseKeyPublicationList = @"publications";
static NSString * const kNBAPIResponseKeyReport = @"report";
static NSString * const kNBAPIResponseKeyVote = @"vote";
static NSString * const kNBAPIResponseKeyComment = @"comment";
static NSString * const kNBAPIResponseKeyCommentList = @"comments";
static NSString * const kNBAPIResponseKeyConversationList = @"conversations";
static NSString * const kNBAPIResponseKeyConversation = @"conversation";
static NSString * const kNBAPIResponseKeyMessageList = @"messages";
static NSString * const kNBAPIResponseKeyUserMessage = @"message";
static NSString * const kNBAPIResponseKeyCategoryList = @"categories";
static NSString * const kNBAPIResponseKeyUserList = @"users";

#pragma mark -


@interface NBAPIResponse ()

@property (strong, nonatomic) NSDictionary *data;

@end


@implementation NBAPIResponse

#pragma mark - Initialisation

- (id)initWithResponseData:(NSDictionary *)data
{
    self = [super init];

    if (self)
    {
        if ([data isKindOfClass:[NSDictionary class]])
        {
            id responseCode = data[kNBAPIResponseKeyCode];
            if ([responseCode isKindOfClass:[NSNumber class]])
                self.responseCode = [responseCode integerValue];
            
            id responseMessage = data[kNBAPIResponseKeyMessage];
            if ([responseMessage isKindOfClass:[NSString class]])
                self.responseMessage = responseMessage;
            
            id responseResult = data[kNBAPIResponseKeyResult];
            if ([responseResult isKindOfClass:[NSDictionary class]])
                self.data = responseResult;
            else
                self.data = [NSDictionary dictionary];
        }
        else
        {
            self.data = [NSDictionary dictionary];
        }
    }

    return self;
}

#pragma mark - Public methods

- (id)dataWithKey:(NSString *)key ofType:(Class)class
{
    id data = self.data[key];

    if ([data isEqual:[NSNull null]] || [data isKindOfClass:class] == NO)
        return nil;
    return data;
}

#pragma mark - Properties

- (BOOL)hasError
{
    static NSInteger const kNBAPIResponseCodeSuccess = 0;

    BOOL hasError = self.responseCode != kNBAPIResponseCodeSuccess;
    return hasError;
}

@end


#pragma mark - Single user

@implementation NBAPIResponseUser

- (NBUser *)user
{
    NSDictionary *rawUser = [self dataWithKey:kNBAPIResponseKeyUser ofType:[NSDictionary class]];
    NBDictionaryDecoder *userDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawUser];
    NBUser *user = [[NBUser alloc] initWithCoder:userDecoder];
    return user;
}

@end


#pragma mark - Single publication

@implementation NBAPIResponsePublication

- (NBPublication *)publication
{
    NSDictionary *rawPublication = [self dataWithKey:kNBAPIResponseKeyPublication ofType:[NSDictionary class]];
    NBDictionaryDecoder *publicationDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawPublication];
    NBPublication *publication = [[NBPublication alloc] initWithCoder:publicationDecoder];
    return publication;
}

@end

#pragma mark - Single place

@implementation NBAPIResponsePlace

- (NBPlace *)place
{
    NSDictionary *rawPlace = [self dataWithKey:kNBAPIResponseKeyPlace ofType:[NSDictionary class]];
    NBDictionaryDecoder *placeDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawPlace];
    NBPlace *place = [[NBPlace alloc] initWithCoder:placeDecoder];
    return place;
}

@end


#pragma mark - Place lsit

@implementation NBAPIResponsePlaceList

- (NSArray *)places
{
    NSArray *rawPlaces = [self dataWithKey:kNBAPIResponseKeyPlaceList ofType:[NSArray class]];

    NSMutableArray *places = [NSMutableArray array];
    for (NSDictionary *rawPlace in rawPlaces)
    {
        NBDictionaryDecoder *placeDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawPlace];
        NBPlace *place = [[NBPlace alloc] initWithCoder:placeDecoder];
        [places addObject:place];
    }

    return [places copy];
}

@end


#pragma mark - Publication list

@implementation NBAPIResponsePublicationList

- (NSArray *)publications
{
    NSArray *rawPublications = [self dataWithKey:kNBAPIResponseKeyPublicationList ofType:[NSArray class]];
    
    NSMutableArray *publications = [NSMutableArray array];
    for (NSDictionary *rawPublication in rawPublications)
    {
        NBDictionaryDecoder *publicationDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawPublication];
        NBPublication *publication = [[NBPublication alloc] initWithCoder:publicationDecoder];
        [publications addObject:publication];
    }
    
    return [publications copy];
}

@end

#pragma mark - Publication report

@implementation NBAPIResponseReportPublication

- (NBReportPublication *)report
{
    NSDictionary *rawReport = [self dataWithKey:kNBAPIResponseKeyReport ofType:[NSDictionary class]];
    NBDictionaryDecoder *reportDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawReport];
    NBReportPublication *report = [[NBReportPublication alloc] initWithCoder:reportDecoder];
    return report;
}

@end

#pragma mark - Comment report

@implementation NBAPIResponseReportComment

- (NBReportComment *)report
{
    NSDictionary *rawReport = [self dataWithKey:kNBAPIResponseKeyReport ofType:[NSDictionary class]];
    NBDictionaryDecoder *reportDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawReport];
    NBReportComment *report = [[NBReportComment alloc] initWithCoder:reportDecoder];
    return report;
}

@end

#pragma mark - Single vote

@implementation NBAPIResponseVote

- (NBVote *)vote
{
    NSDictionary *rawVote = [self dataWithKey:kNBAPIResponseKeyVote ofType:[NSDictionary class]];
    NBDictionaryDecoder *voteDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawVote];
    NBVote *vote = [[NBVote alloc] initWithCoder:voteDecoder];
    return vote;
}

- (NBPublication *)publication
{
    NSDictionary *rawPublication = [self dataWithKey:kNBAPIResponseKeyPublication ofType:[NSDictionary class]];
    NBDictionaryDecoder *publicationDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawPublication];
    NBPublication *publication = [[NBPublication alloc] initWithCoder:publicationDecoder];
    return publication;
}

@end

#pragma mark - Single comment

@implementation NBAPIResponseComment

- (NBComment *)comment
{
    NSDictionary *rawComment = [self dataWithKey:kNBAPIResponseKeyComment ofType:[NSDictionary class]];
    NBDictionaryDecoder *commentDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawComment];
    NBComment *comment = [[NBComment alloc] initWithCoder:commentDecoder];
    return comment;
}

@end

#pragma mark - Comment list

@implementation NBAPIResponseCommentList

- (NSArray *)comments
{
    NSArray *rawComments = [self dataWithKey:kNBAPIResponseKeyCommentList ofType:[NSArray class]];
    
    NSMutableArray *comments = [NSMutableArray array];
    for (NSDictionary *rawComment in rawComments)
    {
        NBDictionaryDecoder *commentDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawComment];
        NBComment *comment = [[NBComment alloc] initWithCoder:commentDecoder];
        [comments addObject:comment];
    }
    
    return [comments copy];
}

@end

#pragma mark - Conversation list

@implementation NBAPIResponseConversationList

- (NSArray *)conversations
{
    NSArray *rawConversations = [self dataWithKey:kNBAPIResponseKeyConversationList ofType:[NSArray class]];
    
    NSMutableArray *conversations = [NSMutableArray array];
    for (NSDictionary *rawConversation in rawConversations)
    {
        NBDictionaryDecoder *conversationDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawConversation];
        NBConversation *conversation = [[NBConversation alloc] initWithCoder:conversationDecoder];
        [conversations addObject:conversation];
    }
    
    return [conversations copy];
}

@end

#pragma mark - Message list

@implementation NBAPIResponseMessageList

- (NSArray *)messages
{
    NSArray *rawMessages = [self dataWithKey:kNBAPIResponseKeyMessageList ofType:[NSArray class]];
    
    NSMutableArray *messages = [NSMutableArray array];
    for (NSDictionary *rawMessage in rawMessages)
    {
        NBDictionaryDecoder *messageDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawMessage];
        NBMessage *message = [[NBMessage alloc] initWithCoder:messageDecoder];
        [messages addObject:message];
    }
    
    return [messages copy];
}

@end

#pragma mark - Single message

@implementation NBAPIResponseMessage

- (NBConversation *)conversation
{
    NSDictionary *rawConversation = [self dataWithKey:kNBAPIResponseKeyConversation ofType:[NSDictionary class]];
    NBDictionaryDecoder *conversationDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawConversation];
    NBConversation *conversation = [[NBConversation alloc] initWithCoder:conversationDecoder];
    return conversation;
}

- (NBMessage *)message
{
    NSDictionary *rawMessage = [self dataWithKey:kNBAPIResponseKeyUserMessage ofType:[NSDictionary class]];
    NBDictionaryDecoder *messageDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawMessage];
    NBMessage *message = [[NBMessage alloc] initWithCoder:messageDecoder];
    return message;
}

@end

#pragma mark - Category list

@implementation NBAPIResponseCategoryList

- (NSArray *)categories
{
    NSArray *rawCategories = [self dataWithKey:kNBAPIResponseKeyCategoryList ofType:[NSArray class]];
    
    NSMutableArray *categories = [NSMutableArray array];
    for (NSDictionary *rawCategory in rawCategories)
    {
        NBDictionaryDecoder *categoryDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawCategory];
        NBPlaceCategory *category = [[NBPlaceCategory alloc] initWithCoder:categoryDecoder];
        [categories addObject:category];
    }
    
    return [categories copy];
}

@end

#pragma mark - User list

@implementation NBAPIResponseUserList

- (NSArray *)users
{
    NSArray *rawUsers = [self dataWithKey:kNBAPIResponseKeyUserList ofType:[NSArray class]];
    
    NSMutableArray *users = [NSMutableArray array];
    for (NSDictionary *rawUser in rawUsers)
    {
        NBDictionaryDecoder *userDecoder = [NBDictionaryDecoder dictonaryCoderWithData:rawUser];
        NBUser *user = [[NBUser alloc] initWithCoder:userDecoder];
        [users addObject:user];
    }
    
    return [users copy];
}

@end