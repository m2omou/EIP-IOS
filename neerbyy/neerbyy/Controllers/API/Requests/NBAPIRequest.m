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

static NSString * const kNBAPIMainKeyUser = @"user";
static NSString * const kNBAPIMainKeyLogin = @"connection";
static NSString * const kNBAPIMainKeyPublication = @"publication";

static NSString * const kNBAPIParamKeyIdentifier = @"id";
static NSString * const kNBAPIParamKeyUserIdentifier = @"user_id";
static NSString * const kNBAPIParamKeyPlaceIdentifier = @"place_id";
static NSString * const kNBAPIParamKeyUsername = @"username";
static NSString * const kNBAPIParamKeyEmail = @"email";
static NSString * const kNBAPIParamKeyPassword = @"password";
static NSString * const kNBAPIParamKeyAvatar = @"avatar";
static NSString * const kNBAPIParamKeyLongitude = @"longitude";
static NSString * const kNBAPIParamKeyLatitude = @"latitude";
static NSString * const kNBAPIParamKeyContent = @"content";
static NSString * const kNBAPIParamKeyFile = @"file";

static NSString * const kNBAPIEndpointLogin = @"sessions.json";
static NSString * const kNBAPIEndpointRegister = @"users.json";
static NSString * const kNBAPIEndpointForgotPassword = @"password_resets.json";
static NSString * const kNBAPIEndpointUsers = @"users.json";
static NSString * const kNBAPIEndpointPlaces = @"places.json";
static NSString * const kNBAPIEndpointPublications = @"publications.json";

#pragma mark -


@implementation NBAPIRequest

#pragma mark - Public methods

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
                                 kNBAPIParamKeyLatitude : @(coordinate.latitude)};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointPlaces
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET];

    operation.APIResponseClass = [NBAPIResponsePlaceList class];
    return operation;
}

+ (NBAPINetworkOperation *)fetchPublicationsForPlace:(NSString *)placeIdentifier
{
    NSDictionary *parameters = @{kNBAPIParamKeyPlaceIdentifier : placeIdentifier};
    
    NBAPINetworkOperation *operation = [NBAPINetworkEngine operationWithPath:kNBAPIEndpointPublications
                                                                      params:parameters
                                                                     mainKey:nil
                                                                  httpMethod:kNBAPIHTTPMethodGET];

    operation.APIResponseClass = [NBAPIResponsePublicationList class];
    return operation;
}

+ (NBAPINetworkOperation *)createPublicationOnPlace:(NSString *)placeIdentifier withImage:(UIImage *)image description:(NSString *)description
{
    NSNumber *loggedUserIdentifier = [NBPersistanceManager sharedManager].currentUser.identifier;
    NSDictionary *parameters = @{kNBAPIParamKeyUserIdentifier : loggedUserIdentifier,
                                 kNBAPIParamKeyPlaceIdentifier : placeIdentifier,
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

@end
