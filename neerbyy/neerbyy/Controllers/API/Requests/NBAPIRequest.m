//
//  NBAPIRequest.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import "NBAPIRequest.h"
#import "NSDictionary+URLEncoding.h"
#import "NBAPINetworkOperation.h"
#import "NBAPINetworkEngine.h"
#import "NBAPIResponse.h"


#pragma mark - Constants

NSString * const kNBAPIUserKey = @"user";
NSString * const kNBAPIUserIDKey = @"id";
NSString * const kNBAPIUserUsernameKey = @"username";
NSString * const kNBAPIUserFirsnameKey = @"firstname";
NSString * const kNBAPIUserLastnameKey = @"lastname";
NSString * const kNBAPIUserEmailKey = @"email";
NSString * const kNBAPIUserPasswordKey = @"password";
NSString * const kNBAPIUserAvatarKey = @"avatar";

NSString * const kNBAPIPlaceIDKey = @"id";
NSString * const kNBAPIPlaceNameKey = @"name";
NSString * const kNBAPIPlaceLongitudeKey = @"longitude";
NSString * const kNBAPIPlaceLatitudeKey = @"latitude";
NSString * const kNBAPIPlaceLimitKey = @"limit";

static NSString * const kNBAPIHTTPMethodPUT = @"PUT";
static NSString * const kNBAPIHTTPMethodPOST = @"POST";
static NSString * const kNBAPIHTTPMethodGET = @"GET";

static NSString * const kNBAPIEndpointLogin = @"sessions.json";
static NSString * const kNBAPIEndpointRegister = @"users.json";
static NSString * const kNBAPIEndpointUsers = @"users.json";
static NSString * const kNBAPIEndpointForgotPassword = @"password_resets.json";
static NSString * const kNBAPIEndpointPlaces = @"places.json";

#pragma mark -


@implementation NBAPIRequest

#pragma mark - Public methods

+ (NBAPINetworkOperation *)imageWithPath:(NSString *)imagePath
{
    NBAPINetworkEngine *engine = [NBAPINetworkEngine engine];
    NBAPINetworkOperation *operation = [engine operationWithPath:imagePath
                                                          params:@{}
                                                      httpMethod:kNBAPIHTTPMethodGET];
    return operation;
}

+ (NBAPINetworkOperation *)loginWithUsername:(NSString *)username
                                    password:(NSString *)password
{
    NSDictionary *parameters = @{kNBAPIUserEmailKey   : username,
                                 kNBAPIUserPasswordKey: password};
    
    NBAPINetworkEngine *engine = [NBAPINetworkEngine engine];
    NBAPINetworkOperation *operation = [engine operationWithPath:kNBAPIEndpointLogin
                                                          params:parameters
                                                      httpMethod:kNBAPIHTTPMethodPOST];
    operation.APIResponseClass = [NBAPIResponseLogin class];
    operation.credentialPersistence = NSURLCredentialPersistenceNone;
    return operation;
}

+ (NBAPINetworkOperation *)registerWithUsername:(NSString *)username
                                       password:(NSString *)password
                                          email:(NSString *)email
                                         avatar:(UIImage *)avatar
{
    NSDictionary *parameters = @{kNBAPIUserUsernameKey: username,
                                 kNBAPIUserPasswordKey: password,
                                 kNBAPIUserEmailKey   : email};
    NSDictionary *userParameters = [@{kNBAPIUserKey: parameters} encodeNestedDictionaryWithPrefix:nil];
    
    NBAPINetworkEngine *engine = [NBAPINetworkEngine engine];
    NBAPINetworkOperation *operation = [engine operationWithPath:kNBAPIEndpointRegister
                                                          params:userParameters
                                                      httpMethod:kNBAPIHTTPMethodPOST];
    [self addImage:avatar toOperation:operation withKey:@"user[avatar]"];
    operation.APIResponseClass = [NBAPIResponseRegister class];
    return operation;
}

+ (NBAPINetworkOperation *)sendForgetPasswordWithEmail:(NSString *)email
{
    NSDictionary *parameters = @{kNBAPIUserEmailKey: email};
    
    NBAPINetworkEngine *engine = [NBAPINetworkEngine engine];
    NBAPINetworkOperation *operation = [engine operationWithPath:kNBAPIEndpointForgotPassword
                                                          params:parameters
                                                      httpMethod:kNBAPIHTTPMethodPOST];
    operation.APIResponseClass = [NBAPIResponse class];
    return operation;
}

+ (NBAPINetworkOperation *)fetchPlacesAroundCoordinate:(CLLocationCoordinate2D)coordinate
                                             withLimit:(NSNumber *)limit
{
    NSDictionary *parameters = @{kNBAPIPlaceLongitudeKey: @(coordinate.longitude),
                                 kNBAPIPlaceLatitudeKey : @(coordinate.latitude),
                                 kNBAPIPlaceLimitKey    : (limit ? limit : @0)};
    
    NBAPINetworkEngine *engine = [NBAPINetworkEngine engine];
    NBAPINetworkOperation *operation = [engine operationWithPath:kNBAPIEndpointPlaces
                                                          params:parameters
                                                      httpMethod:kNBAPIHTTPMethodGET];
    operation.APIResponseClass = [NBAPIResponsePlaceList class];
    return operation;
}

#pragma mark - Private methods

+ (void)addImage:(UIImage *)image toOperation:(NBAPINetworkOperation *)operation withKey:(NSString *)key
{
    if (!image)
        return ;
    
    NSString *extension = @"png";
    NSString *mimeType = [@"image" stringByAppendingPathComponent:extension];
    NSString *fileName = [key stringByAppendingPathExtension:extension];
    NSData *imageData = UIImagePNGRepresentation(image);
    [operation addData:imageData forKey:key mimeType:mimeType fileName:fileName];
}

@end
