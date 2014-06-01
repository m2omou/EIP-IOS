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
static NSString * const kNBAPIMainKeyFollowedPlaces = @"relationships";
static NSString * const kNBAPIMainKeyReport = @"report";
static NSString * const kNBAPIMainKeyVote = @"vote";
static NSString * const kNBAPIMainKeyComment = @"comment";

static NSString * const kNBAPIParamKeyIdentifier = @"id";
static NSString * const kNBAPIParamKeyPlaceIdentifier = @"place_id";
static NSString * const kNBAPIParamKeyPublicationIdentifier = @"publication_id";
static NSString * const kNBAPIParamKeyCommentIdentifier = @"comment_id";
static NSString * const kNBAPIParamKeyUsername = @"username";
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
static NSString * const kNBAPIParamKeyAfter = @"after_id";
static NSString * const kNBAPIParamKeyReportReason = @"reason";
static NSString * const kNBAPIParamKeyValue = @"value";

static NSString * const kNBAPIEndpointLogin = @"sessions";
static NSString * const kNBAPIEndpointRegister = @"users";
static NSString * const kNBAPIEndpointForgotPassword = @"password_resets";
static NSString * const kNBAPIEndpointUsers = @"users";
static NSString * const kNBAPIEndpointPlaces = @"places";
static NSString * const kNBAPIEndpointFollowedPlaces = @"relationships";
static NSString * const kNBAPIEndpointPublications = @"publications";
static NSString * const kNBAPIEndpointReportPublications = @"report_publications";
static NSString * const kNBAPIEndpointFlow = @"flow";
static NSString * const kNBAPIEndpointVotes = @"votes";
static NSString * const kNBAPIEndpointComments = @"comments";
static NSString * const kNBAPIEndpointReportComments = @"report_comments";

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
                                                                  httpMethod:kNBAPIHTTPMethodPOST];
    
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
    NSNumber *endPointParam = [NBPersistanceManager sharedManager].currentUser.identifier;
    NSString *endPoint = [NSString stringWithFormat:@"%@/%@", kNBAPIEndpointLogin, endPointParam];

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






+ (NBAPINetworkOperation *)fetchPlacesAroundCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSDictionary *parameters = @{kNBAPIParamKeyLongitude : @(coordinate.longitude),
                                 kNBAPIParamKeyLatitude : @(coordinate.latitude),
                                 kNBAPIParamKeyLimit: @50};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointPlaces
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET];

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

+ (NBAPINetworkOperation *)fetchFollowedPlacesWithParams:(NSDictionary *)parameters
{
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointFollowedPlaces
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET];
    operation.APIResponseClass = [NBAPIResponsePlaceList class];
    return operation;
}

+ (NBAPINetworkOperation *)followPlace:(NSNumber *)placeId
{
    NSDictionary *parameters = @{kNBAPIParamKeyPlaceIdentifier: placeId};

    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointFollowedPlaces
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyFollowedPlaces
                                                                  httpMethod:kNBAPIHTTPMethodPOST];
    operation.APIResponseClass = [NBAPIResponsePlace class];
    return operation;
}

+ (NBAPINetworkOperation *)unfollowPlace:(NSNumber *)placeId
{
    NSDictionary *parameters = @{};
    NSNumber *endPointParam = placeId;
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

+ (NBAPINetworkOperation *)fetchPublicationsWithParams:(NSDictionary *)parameters
{
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointPublications
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET];
    
    operation.APIResponseClass = [NBAPIResponsePublicationList class];
    return operation;
}

+ (NBAPINetworkOperation *)createPublicationOnPlace:(NSString *)placeIdentifier atPosition:(CLLocationCoordinate2D)position
                                          withImage:(UIImage *)image description:(NSString *)description
{
    NSDictionary *parameters = @{kNBAPIParamKeyPlaceIdentifier : placeIdentifier,
                                 kNBAPIParamKeyLongitude : @(position.longitude),
                                 kNBAPIParamKeyLatitude : @(position.latitude),
                                 kNBAPIParamKeyContent : description};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointPublications
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyPublication
                                                                       image:image
                                                                    imageKey:kNBAPIParamKeyFile
                                                                  httpMethod:kNBAPIHTTPMethodPOST];
    
    operation.APIResponseClass = [NBAPIResponsePublication class];
    return operation;
}

+ (NBAPINetworkOperation *)createPublicationOnPlace:(NSString *)placeIdentifier atPosition:(CLLocationCoordinate2D)position
                                            withURL:(NSString *)url description:(NSString *)description
{
    NSDictionary *parameters = @{kNBAPIParamKeyPlaceIdentifier : placeIdentifier,
                                 kNBAPIParamKeyLongitude : @(position.longitude),
                                 kNBAPIParamKeyLatitude : @(position.latitude),
                                 kNBAPIParamKeyURL : url,
                                 kNBAPIParamKeyContent : description};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointPublications
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyPublication
                                                                  httpMethod:kNBAPIHTTPMethodPOST];
    
    operation.APIResponseClass = [NBAPIResponsePublication class];
    return operation;
}

+ (NBAPINetworkOperation *)createPublicationOnPlace:(NSString *)placeIdentifier atPosition:(CLLocationCoordinate2D)position
                                            withDescription:(NSString *)description
{
    NSDictionary *parameters = @{kNBAPIParamKeyPlaceIdentifier : placeIdentifier,
                                 kNBAPIParamKeyLongitude : @(position.longitude),
                                 kNBAPIParamKeyLatitude : @(position.latitude),
                                 kNBAPIParamKeyContent : description};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointPublications
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyPublication
                                                                  httpMethod:kNBAPIHTTPMethodPOST];
    
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

+ (NBAPINetworkOperation *)reportPublication:(NSNumber *)publicationId
{
    NSDictionary *parameters = @{kNBAPIParamKeyPublicationIdentifier: publicationId,
                                 kNBAPIParamKeyReportReason: @4,
                                 kNBAPIParamKeyContent: @"Lolilol"}; /* TODO : This is wrong */
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointReportPublications
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyReport
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

+ (NBAPINetworkOperation *)reportComment:(NSNumber *)commentId
{
    NSDictionary *parameters = @{kNBAPIParamKeyCommentIdentifier: commentId,
                                 kNBAPIParamKeyReportReason: @4,
                                 kNBAPIParamKeyContent: @"Lolilol"}; /* TODO : This is wrong */
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointReportComments
                                                                      params:parameters
                                                                     mainKey:kNBAPIMainKeyReport
                                                                  httpMethod:kNBAPIHTTPMethodPOST];
    
    operation.APIResponseClass = [NBAPIResponseReportComment class];
    return operation;
}

@end
