//
//  NBEngine.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import "NBAPINetworkEngine.h"
#import "NBAPINetworkOperation.h"
#import "NSDictionary+URLEncoding.h"
#import "NBAPINetworkOperation+UIImage.h"
#import "NBUser.h"
#import "NBPersistanceManager.h"


#pragma mark - Constants

static NSString * const kNBAPIFormat = @".json";

#ifdef DEBUG
static NSString * const kNBAPIHostname = @"api.neerbyy.com";
#else
static NSString * const kNBAPIHostname = @"api.neerbyy.com";
#endif
#pragma mark -

static NBAPINetworkEngine *engine;

@implementation NBAPINetworkEngine

#pragma mark - Singleton

+ (instancetype)engine
{
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token, ^{
        [self resetEngine];
        [UIImageView setDefaultEngine:engine];
    });
    
    return engine;
}

+ (void)resetEngine
{
    engine = [[NBAPINetworkEngine alloc] initWithHostName:kNBAPIHostname];
    [engine useCache];
    [engine emptyCache];
    [engine useCache];
    [engine registerOperationSubclass:[NBAPINetworkOperation class]];
}

#pragma mark - Public methods

+ (NBAPINetworkOperation *)operationWithPath:(NSString *)path params:(NSDictionary *)params mainKey:(NSString *)mainKey httpMethod:(NSString *)method
{
    return [self operationWithPath:path params:params mainKey:mainKey image:nil imageKey:nil httpMethod:method addLocation:NO];
}

+ (NBAPINetworkOperation *)operationWithPath:(NSString *)path params:(NSDictionary *)params mainKey:(NSString *)mainKey httpMethod:(NSString *)method addLocation:(BOOL)shouldAddLocation
{
    return [self operationWithPath:path params:params mainKey:mainKey image:nil imageKey:nil httpMethod:method addLocation:shouldAddLocation];
}

+ (NBAPINetworkOperation *)operationWithPath:(NSString *)path params:(NSDictionary *)params mainKey:(NSString *)mainKey image:(UIImage *)image imageKey:(NSString *)imageKey httpMethod:(NSString *)method addLocation:(BOOL)shouldAddLocation
{
    path = [path stringByAppendingString:kNBAPIFormat];
    if (shouldAddLocation)
        params = [self paramsByAddingLocationOnParams:params];
    params = [params encodeNestedDictionaryWithPrefix:mainKey];

    NBAPINetworkOperation *operation = (NBAPINetworkOperation *)[[NBAPINetworkEngine engine] operationWithPath:path
                                                                                                        params:params
                                                                                                    httpMethod:method];
    if (image)
        [operation addImage:image withKey:imageKey mainKey:mainKey];
    
#ifdef DEBUG
    [operation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        NSLog(@"Operation with curl command :\n%@", operation.curlCommandLineString);
        NSLog(@"[SUCCESS] with response string :\n%@", operation.responseString);
        NSLog(@"Headers : %@", [[NSString alloc] initWithData:operation.readonlyRequest.HTTPBody encoding:4]) ;
    } errorHandler:^(NBAPINetworkOperation *operation, NSError *error) {
        NSLog(@"Operation with curl command :\n%@", operation.curlCommandLineString);
        NSLog(@"[FAILED] with response string :\n%@", operation.responseString);
    }];
#endif
    
    return (NBAPINetworkOperation *)operation;
}

+ (NSDictionary *)paramsByAddingLocationOnParams:(NSDictionary *)params
{
    static NSString * const kNBAPIParamKeyLongitude = @"user_longitude";
    static NSString * const kNBAPIParamKeyLatitude = @"user_latitude";

    NSMutableDictionary *parameters = [params mutableCopy];
    
    NBPersistanceManager *persistanceManager = [NBPersistanceManager sharedManager];
    CLLocationCoordinate2D position = persistanceManager.lastKnownLocation;
    if (CLLocationCoordinate2DIsValid(position))
    {
        parameters[kNBAPIParamKeyLongitude] = @(position.longitude);
        parameters[kNBAPIParamKeyLatitude] = @(position.latitude);
    }
    
    return [parameters copy];
}

@end
