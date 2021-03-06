//
//  NBAPIRequest.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import "NBAPIRequest.h"
#import "NBPersistanceManager.h"
#import "NBUser.h"
#import "NSDictionary+URLEncoding.h"
#import "NBAPINetworkOperation.h"
#import "NBAPINetworkEngine.h"
#import "NBAPIResponse.h"


#pragma mark - Constants

static NSString * const kNBAPIHTTPMethodPUT = @"PUT";
static NSString * const kNBAPIHTTPMethodPOST = @"POST";
static NSString * const kNBAPIHTTPMethodGET = @"GET";
static NSString * const kNBAPIHTTPMethodDELETE = @"DELETE";

static NSString * const kNBAPIMainKeyUser = @"user";
static NSString * const kNBAPIMainKeyLogin = @"connection";
static NSString * const kNBAPIMainKeyPublication = @"publication";
static NSString * const kNBAPIMainKeyFollowedPlaces = @"followed_place";
static NSString * const kNBAPIMainKeyReportPublication = @"report_publication";
static NSString * const kNBAPIMainKeyReportComment = @"report_comment";
static NSString * const kNBAPIMainKeyVote = @"vote";
static NSString * const kNBAPIMainKeyComment = @"comment";
static NSString * const kNBAPIMainKeyMessage = @"message";
static NSString * const kNBAPIMainKeySettings = @"setting";

static NSString * const kNBAPIParamKeyIdentifier = @"id";
static NSString * const kNBAPIParamKeyPlaceIdentifier = @"place_id";
static NSString * const kNBAPIParamKeyPublicationIdentifier = @"publication_id";
static NSString * const kNBAPIParamKeyCommentIdentifier = @"comment_id";
static NSString * const kNBAPIParamKeyUsername = @"username";
static NSString * const kNBAPIParamKeyUserIdentifier = @"user_id";
static NSString * const kNBAPIParamKeyEmail = @"email";
static NSString * const kNBAPIParamKeyPassword = @"password";
static NSString * const kNBAPIParamKeyAvatar = @"avatar";
static NSString * const kNBAPIParamKeyLongitude = @"longitude";
static NSString * const kNBAPIParamKeyLatitude = @"latitude";
static NSString * const kNBAPIParamKeyContent = @"content";
static NSString * const kNBAPIParamKeyFile = @"file";
static NSString * const kNBAPIParamKeyLimit = @"limit";
static NSString * const kNBAPIParamKeyURL = @"link";
static NSString * const kNBAPIParamKeySince = @"since_id";
static NSString * const kNBAPIParamKeyAfter = @"max_id";
static NSString * const kNBAPIParamKeyReportReason = @"reason";
static NSString * const kNBAPIParamKeyValue = @"value";
static NSString * const kNBAPIParamKeyConversationIdentifier = @"conversation_id";
static NSString * const kNBAPIParamKeyRecipentIdentifier = @"recipient_id";
static NSString * const kNBAPIParamKeyCategory = @"category_id";
static NSString * const kNBAPIParamKeyQuery = @"query";
static NSString * const kNBAPIParamKeyFirstname = @"firstname";
static NSString * const kNBAPIParamKeyLastname = @"lastname";
static NSString * const kNBAPIParamKeyCurrentPassword = @"current_password";

static NSString * const kNBAPIEndpointLogin = @"sessions";
static NSString * const kNBAPIEndpointLogout = @"log_out";
static NSString * const kNBAPIEndpointRegister = @"users";
static NSString * const kNBAPIEndpointForgotPassword = @"password_resets";
static NSString * const kNBAPIEndpointUsers = @"users";
static NSString * const kNBAPIEndpointSearchUsers = @"search/users";
static NSString * const kNBAPIEndpointPlaces = @"places";
static NSString * const kNBAPIEndpointSearchPlaces = @"search/places";
static NSString * const kNBAPIEndpointFollowedPlaces = @"followed_places";
static NSString * const kNBAPIEndpointPublications = @"publications";
static NSString * const kNBAPIEndpointReportPublications = @"report_publications";
static NSString * const kNBAPIEndpointFlow = @"flows";
static NSString * const kNBAPIEndpointVotes = @"votes";
static NSString * const kNBAPIEndpointComments = @"comments";
static NSString * const kNBAPIEndpointReportComments = @"report_comments";
static NSString * const kNBAPIEndpointConversations = @"conversations";
static NSString * const kNBAPIEndpointMessages = @"messages";
static NSString * const kNBAPIEndpointCategories = @"categories";
static NSString * const kNBAPIEndpointSettings = @"settings";

#pragma mark -


@implementation NBAPIRequest

#pragma mark - Public methods

+ (NBAPINetworkOperation *)registerWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email avatar:(UIImage *)avatar
{
    NSDictionary *parameters = @{kNBAPIParamKeyUsername : username,
                                 kNBAPIParamKeyPassword : password,
                                 kNBAPIParamKeyEmail : email};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointRegister
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyUser
                                                                       image:avatar
                                                                    imageKey:kNBAPIParamKeyAvatar
                                                                  httpMethod:kNBAPIHTTPMethodPOST
                                                                 addLocation:NO];
    
    operation.APIResponseClass = [NBAPIResponseUser class];
    return operation;
}







+ (NBAPINetworkOperation *)loginWithUsername:(NSString *)username password:(NSString *)password
{
    NSDictionary *parameters = @{kNBAPIParamKeyEmail : username,
                                 kNBAPIParamKeyPassword : password};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointLogin
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyLogin
                                                                  httpMethod:kNBAPIHTTPMethodPOST];

    operation.APIResponseClass = [NBAPIResponseUser class];
    operation.credentialPersistence = NSURLCredentialPersistenceNone;
    return operation;
}

+ (NBAPINetworkOperation *)logout
{
    NSDictionary *parameters = @{};

    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointLogout
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET];
    operation.APIResponseClass = [NBAPIResponse class];
    return operation;
}





+ (NBAPINetworkOperation *)updateFirstName:(NSString *)firstName lastName:(NSString *)lastName username:(NSString *)username
                                     email:(NSString *)email password:(NSString *)password avatar:(UIImage *)avatar
                           currentPassword:(NSString *)currentPassword
{
    NSDictionary *parameters = @{kNBAPIParamKeyFirstname : firstName,
                                 kNBAPIParamKeyLastname : lastName,
                                 kNBAPIParamKeyUsername : username,
                                 kNBAPIParamKeyEmail : email};
    NSNumber *endPointParam = [NBPersistanceManager sharedManager].currentUser.identifier;
    NSString *endPoint = [NSString stringWithFormat:@"%@/%@", kNBAPIEndpointUsers, endPointParam];
    if (password.length)
    {
        NSMutableDictionary *mutableParameters = [parameters mutableCopy];
        mutableParameters[kNBAPIParamKeyPassword] = password;
        parameters = [mutableParameters copy];
    }
    if (currentPassword.length)
    {
        NSMutableDictionary *mutableParameters = [parameters mutableCopy];
        mutableParameters[kNBAPIParamKeyCurrentPassword] = currentPassword;
        parameters = [mutableParameters copy];
    }

    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:endPoint
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyUser
                                                                       image:avatar
                                                                    imageKey:kNBAPIParamKeyAvatar
                                                                  httpMethod:kNBAPIHTTPMethodPUT
                                                                 addLocation:NO];
    
    operation.APIResponseClass = [NBAPIResponseUser class];
    return operation;
}

+ (NBAPINetworkOperation *)deleteAccount
{
    NSDictionary *parameters = @{};
    NSNumber *endPointParam = [NBPersistanceManager sharedManager].currentUser.identifier;
    NSString *endPoint = [NSString stringWithFormat:@"%@/%@", kNBAPIEndpointUsers, endPointParam];
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:endPoint
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodDELETE];
    operation.APIResponseClass = [NBAPIResponse class];
    return operation;
}





+ (NBAPINetworkOperation *)sendForgetPasswordWithEmail:(NSString *)email
{
    NSDictionary *parameters = @{kNBAPIParamKeyEmail: email};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointForgotPassword
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodPOST];

    operation.APIResponseClass = [NBAPIResponse class];
    return operation;
}




+ (NBAPINetworkOperation *)fetchCategories
{
    NSDictionary *parameters = @{};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointCategories
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET];
    
    operation.APIResponseClass = [NBAPIResponseCategoryList class];
    return operation;
}

+ (NBAPINetworkOperation *)fetchPlacesAroundCoordinate:(CLLocationCoordinate2D)coordinate withCategory:(NSString *)categoryId
{
    NSDictionary *parameters = @{kNBAPIParamKeyLongitude : @(coordinate.longitude),
                                 kNBAPIParamKeyLatitude : @(coordinate.latitude),
                                 kNBAPIParamKeyLimit: @50};
    if (categoryId)
    {
        NSMutableDictionary *mutableParams = [parameters mutableCopy];
        mutableParams[kNBAPIParamKeyCategory] = categoryId;
        parameters = [mutableParams copy];
    }
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointPlaces
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET
                                                                 addLocation:YES];

    operation.APIResponseClass = [NBAPIResponsePlaceList class];
    return operation;
}

+ (NBAPINetworkOperation *)fetchPlacesWithName:(NSString *)name
{
    NSDictionary *parameters = @{kNBAPIParamKeyQuery: name};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointSearchPlaces
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET
                                                                 addLocation:YES];
    
    operation.APIResponseClass = [NBAPIResponsePlaceList class];
    return operation;
}

+ (NBAPINetworkOperation *)fetchFollowedPlaces
{
    NSDictionary *parameters = @{};
    return [self fetchFollowedPlacesWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchFollowedPlacesSinceId:(NSNumber *)sinceId
{
    NSDictionary *parameters = @{kNBAPIParamKeySince: sinceId};
    return [self fetchFollowedPlacesWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchFollowedPlacesAfterId:(NSNumber *)afterId
{
    NSDictionary *parameters = @{kNBAPIParamKeyAfter: afterId};
    return [self fetchFollowedPlacesWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchFollowedPlacesForUser:(NSNumber *)userId
{
    NSDictionary *parameters = @{kNBAPIParamKeyUserIdentifier: userId};
    return [self fetchFollowedPlacesWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchFollowedPlacesForUser:(NSNumber *)userId sinceId:(NSString *)sinceId
{
    NSDictionary *parameters = @{kNBAPIParamKeyUserIdentifier: userId,
                                 kNBAPIParamKeySince: sinceId};
    return [self fetchFollowedPlacesWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchFollowedPlacesForUser:(NSNumber *)userId afterId:(NSString *)afterId
{
    NSDictionary *parameters = @{kNBAPIParamKeyUserIdentifier: userId,
                                 kNBAPIParamKeyAfter: afterId};
    return [self fetchFollowedPlacesWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchFollowedPlacesWithParams:(NSDictionary *)parameters
{
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointFollowedPlaces
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET
                                                                 addLocation:YES];
    operation.APIResponseClass = [NBAPIResponsePlaceList class];
    return operation;
}

+ (NBAPINetworkOperation *)followPlace:(NSString *)placeId
{
    NSDictionary *parameters = @{kNBAPIParamKeyPlaceIdentifier: placeId};

    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointFollowedPlaces
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyFollowedPlaces
                                                                  httpMethod:kNBAPIHTTPMethodPOST];
    operation.APIResponseClass = [NBAPIResponsePlace class];
    return operation;
}

+ (NBAPINetworkOperation *)unfollowPlace:(NSNumber *)followingId
{
    NSDictionary *parameters = @{};
    NSNumber *endPointParam = followingId;
    NSString *endPoint = [NSString stringWithFormat:@"%@/%@", kNBAPIEndpointFollowedPlaces, endPointParam];
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:endPoint
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodDELETE];
    operation.APIResponseClass = [NBAPIResponse class];
    return operation;
}







+ (NBAPINetworkOperation *)fetchPublicationsForPlace:(NSString *)placeIdentifier
{
    NSDictionary *parameters = @{kNBAPIParamKeyPlaceIdentifier : placeIdentifier};
    return [self fetchPublicationsWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchPublicationsForPlace:(NSString *)placeIdentifier sinceId:(NSNumber *)sinceId
{
    NSDictionary *parameters = @{kNBAPIParamKeyPlaceIdentifier: placeIdentifier,
                                 kNBAPIParamKeySince: sinceId};
    return [self fetchPublicationsWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchPublicationsForPlace:(NSString *)placeIdentifier afterId:(NSNumber *)afterId
{
    NSDictionary *parameters = @{kNBAPIParamKeyPlaceIdentifier: placeIdentifier,
                                 kNBAPIParamKeyAfter: afterId};
    return [self fetchPublicationsWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchPublicationsForUser:(NSNumber *)userIdentifier
{
    NSDictionary *parameters = @{kNBAPIParamKeyUserIdentifier: userIdentifier};
    return [self fetchPublicationsWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchPublicationsForUser:(NSNumber *)userIdentifier sinceId:(NSNumber *)sinceId
{
    NSDictionary *parameters = @{kNBAPIParamKeyUserIdentifier: userIdentifier,
                                 kNBAPIParamKeySince: sinceId};
    return [self fetchPublicationsWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchPublicationsForUser:(NSNumber *)userIdentifier afterId:(NSNumber *)afterId
{
    NSDictionary *parameters = @{kNBAPIParamKeyUserIdentifier: userIdentifier,
                                 kNBAPIParamKeyAfter: afterId};
    return [self fetchPublicationsWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchPublicationsWithParams:(NSDictionary *)parameters
{
    NSMutableDictionary *params = [parameters mutableCopy];
    params[@"count"] = @1;
    parameters = [params copy];
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointPublications
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET];
    
    operation.APIResponseClass = [NBAPIResponsePublicationList class];
    return operation;
}

+ (NBAPINetworkOperation *)createPublicationOnPlace:(NSString *)placeIdentifier withImage:(UIImage *)image description:(NSString *)description
{
    NSDictionary *parameters = @{kNBAPIParamKeyPlaceIdentifier : placeIdentifier,
                                 kNBAPIParamKeyContent : description};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointPublications
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyPublication
                                                                       image:image
                                                                    imageKey:kNBAPIParamKeyFile
                                                                  httpMethod:kNBAPIHTTPMethodPOST
                                                                 addLocation:YES];
    
    operation.APIResponseClass = [NBAPIResponsePublication class];
    return operation;
}

+ (NBAPINetworkOperation *)createPublicationOnPlace:(NSString *)placeIdentifier withURL:(NSString *)url description:(NSString *)description
{
    NSDictionary *parameters = @{kNBAPIParamKeyPlaceIdentifier : placeIdentifier,
                                 kNBAPIParamKeyURL : url,
                                 kNBAPIParamKeyContent : description};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointPublications
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyPublication
                                                                  httpMethod:kNBAPIHTTPMethodPOST
                                                                 addLocation:YES];
    
    operation.APIResponseClass = [NBAPIResponsePublication class];
    return operation;
}

+ (NBAPINetworkOperation *)createPublicationOnPlace:(NSString *)placeIdentifier withDescription:(NSString *)description
{
    NSDictionary *parameters = @{kNBAPIParamKeyPlaceIdentifier : placeIdentifier,
                                 kNBAPIParamKeyContent : description};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointPublications
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyPublication
                                                                  httpMethod:kNBAPIHTTPMethodPOST
                                                                 addLocation:YES];
    
    operation.APIResponseClass = [NBAPIResponsePublication class];
    return operation;
}

+ (NBAPINetworkOperation *)deletePublication:(NSNumber *)publicationId
{
    NSDictionary *parameters = @{};
    NSNumber *endPointParam = publicationId;
    NSString *endPoint = [NSString stringWithFormat:@"%@/%@", kNBAPIEndpointPublications, endPointParam];
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:endPoint
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodDELETE];
    operation.APIResponseClass = [NBAPIResponse class];
    return operation;
}

+ (NBAPINetworkOperation *)reportPublication:(NSNumber *)publicationId withDescription:(NSString *)description forReason:(NSNumber *)reason
{
    NSDictionary *parameters = @{kNBAPIParamKeyPublicationIdentifier: publicationId,
                                 kNBAPIParamKeyReportReason: reason,
                                 kNBAPIParamKeyContent: description};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointReportPublications
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyReportPublication
                                                                  httpMethod:kNBAPIHTTPMethodPOST];
    
    operation.APIResponseClass = [NBAPIResponseReportPublication class];
    return operation;
}







+ (NBAPINetworkOperation *)fetchFlow
{
    NSDictionary *parameters = @{};
    return [self fetchFlowWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchFlowSinceId:(NSNumber *)sinceId
{
    NSDictionary *parameters = @{kNBAPIParamKeySince: sinceId};
    return [self fetchFlowWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchFlowAfterId:(NSNumber *)afterId
{
    NSDictionary *parameters = @{kNBAPIParamKeyAfter: afterId};
    return [self fetchFlowWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchFlowWithParams:(NSDictionary *)parameters
{
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointFlow
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET];
    operation.APIResponseClass = [NBAPIResponsePublicationList class];
    return  operation;
}








+ (NBAPINetworkOperation *)voteOnPublication:(NSNumber *)publicationId withValue:(NBVoteValue)value
{
    NSDictionary *parameters = @{kNBAPIParamKeyPublicationIdentifier: publicationId,
                                 kNBAPIParamKeyValue: @(value)};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointVotes
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyVote
                                                                  httpMethod:kNBAPIHTTPMethodPOST];
    
    operation.APIResponseClass = [NBAPIResponseVote class];
    return operation;
}

+ (NBAPINetworkOperation *)cancelVote:(NSNumber *)voteId
{
    NSDictionary *parameters = @{};
    NSNumber *endPointParam = voteId;
    NSString *endPoint = [NSString stringWithFormat:@"%@/%@", kNBAPIEndpointVotes, endPointParam];
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:endPoint
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodDELETE];
    operation.APIResponseClass = [NBAPIResponseVote class];
    return operation;
}





+ (NBAPINetworkOperation *)fetchCommentsForPublication:(NSNumber *)publicationId
{
    NSDictionary *parameters = @{kNBAPIParamKeyPublicationIdentifier: publicationId};
    return [self fetchCommentsWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchCommentsForPublication:(NSNumber *)publicationId sinceId:(NSNumber *)sinceId
{
    NSDictionary *parameters = @{kNBAPIParamKeyPublicationIdentifier: publicationId,
                                 kNBAPIParamKeySince: sinceId};
    return [self fetchCommentsWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchCommentsForPublication:(NSNumber *)publicationId afterId:(NSNumber *)afterId
{
    NSDictionary *parameters = @{kNBAPIParamKeyPublicationIdentifier: publicationId,
                                 kNBAPIParamKeyAfter: afterId};
    return [self fetchCommentsWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchCommentsWithParams:(NSDictionary *)parameters
{
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointComments
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET];
    operation.APIResponseClass = [NBAPIResponseCommentList class];
    return operation;
}

+ (NBAPINetworkOperation *)commentOnPublication:(NSNumber *)publicationId withMessage:(NSString *)message
{
    NSDictionary *parameters = @{kNBAPIParamKeyPublicationIdentifier: publicationId,
                                 kNBAPIParamKeyContent: message};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointComments
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyComment
                                                                  httpMethod:kNBAPIHTTPMethodPOST];
    operation.APIResponseClass = [NBAPIResponseComment class];
    return operation;
}

+ (NBAPINetworkOperation *)removeComment:(NSNumber *)commentId
{
    NSDictionary *parameters = @{};
    NSNumber *endPointParam = commentId;
    NSString *endPoint = [NSString stringWithFormat:@"%@/%@", kNBAPIEndpointComments, endPointParam];
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:endPoint
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodDELETE];
    operation.APIResponseClass = [NBAPIResponse class];
    return operation;
}

+ (NBAPINetworkOperation *)reportComment:(NSNumber *)commentId withDescription:(NSString *)description forReason:(NSNumber *)reason
{
    NSDictionary *parameters = @{kNBAPIParamKeyCommentIdentifier: commentId,
                                 kNBAPIParamKeyReportReason: reason,
                                 kNBAPIParamKeyContent: description};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointReportComments
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyReportComment
                                                                  httpMethod:kNBAPIHTTPMethodPOST];
    
    operation.APIResponseClass = [NBAPIResponseReportComment class];
    return operation;
}




+ (NBAPINetworkOperation *)fetchConversations
{
    NSDictionary *parameters = @{};
    return [self fetchConversationsWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchConversationsSinceId:(NSNumber *)sinceId
{
    NSDictionary *parameters = @{kNBAPIParamKeySince: sinceId};
    return [self fetchConversationsWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchConversationsAfterId:(NSNumber *)afterId
{
    NSDictionary *parameters = @{kNBAPIParamKeyAfter: afterId};
    return [self fetchConversationsWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchConversationsWithParams:(NSDictionary *)parameters
{
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointConversations
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET];
    operation.APIResponseClass = [NBAPIResponseConversationList class];
    return  operation;
}





+ (NBAPINetworkOperation *)fetchMessagesForConversation:(NSNumber *)conversationId
{
    NSDictionary *parameters = @{kNBAPIParamKeyConversationIdentifier: conversationId};
    return [self fetchMessagesWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchMessagesForConversation:(NSNumber *)conversationId sinceId:(NSNumber *)sinceId
{
    NSDictionary *parameters = @{kNBAPIParamKeyConversationIdentifier: conversationId,
                                 kNBAPIParamKeySince: sinceId};
    return [self fetchMessagesWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchMessagesForConversation:(NSNumber *)conversationId afterId:(NSNumber *)afterId
{
    NSDictionary *parameters = @{kNBAPIParamKeyConversationIdentifier: conversationId,
                                 kNBAPIParamKeyAfter: afterId};
    return [self fetchMessagesWithParams:parameters];
}

+ (NBAPINetworkOperation *)fetchMessagesWithParams:(NSDictionary *)parameters
{
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointMessages
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET];
    operation.APIResponseClass = [NBAPIResponseMessageList class];
    return operation;
}

+ (NBAPINetworkOperation *)sendMessageToUser:(NSNumber *)userIdentifier withContent:(NSString *)content
{
    NSDictionary *parameters = @{kNBAPIParamKeyRecipentIdentifier: userIdentifier,
                                 kNBAPIParamKeyContent: content};
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointMessages
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyMessage
                                                                  httpMethod:kNBAPIHTTPMethodPOST];
    operation.APIResponseClass = [NBAPIResponseMessage class];
    return operation;
}




+ (NBAPINetworkOperation *)fetchUserWithUsername:(NSString *)username
{
    NSDictionary *parameters = @{kNBAPIParamKeyQuery: username};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointSearchUsers
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET];
    
    operation.APIResponseClass = [NBAPIResponseUserList class];
    return operation;
}

+ (NBAPINetworkOperation *)updateSettings:(NBSettings *)settings
{
    NSDictionary *parameters = [settings toDictionary];
    NSNumber *endPointParam = settings.identifier;
    NSString *endPoint = [NSString stringWithFormat:@"%@/%@", kNBAPIEndpointSettings, endPointParam];
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:endPoint
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeySettings
                                                                  httpMethod:kNBAPIHTTPMethodPUT];
    
    operation.APIResponseClass = [NBAPIResponse class];
    return operation;
}

@end
