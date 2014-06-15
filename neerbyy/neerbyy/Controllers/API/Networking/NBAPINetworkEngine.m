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
static NSString * const kNBAPIHostname = @"neerbyy.com";

#pragma mark -

static NBAPINetworkEngine *engine;

@implementation NBAPINetworkEngine

#pragma mark - Singleton

+ (instancetype)engine
{
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token, ^{
        [self resetEngine];
        
        MKNetworkEngine *imageEngine = [MKNetworkEngine new];
        [imageEngine useCache];
        [UIImageView setDefaultEngine:imageEngine];
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
    return [self operationWithPath:path params:params mainKey:mainKey image:nil imageKey:nil httpMethod:method];
}

+ (NBAPINetworkOperation *)operationWithPath:(NSString *)path params:(NSDictionary *)params mainKey:(NSString *)mainKey image:(UIImage *)image imageKey:(NSString *)imageKey httpMethod:(NSString *)method
{
    path = [path stringByAppendingString:kNBAPIFormat];
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

+ (void)addAuthHeaderIfNeeded:(NBAPINetworkOperation *)operation
{
    NBPersistanceManager *persistanceManager = [NBPersistanceManager sharedManager];
    
    if (persistanceManager.isConnected)
    {
        NBUser *user = persistanceManager.currentUser;
        NSString *token = user.token;
        NSString *formattedToken = [NSString stringWithFormat:@"Token token=\"%@\"", token];
        [operation setHeader:@"Authorization" withValue:formattedToken];
    }
}

@end
