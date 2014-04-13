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


#pragma mark - Constants

static NSString * const kNBAPIHostname = @"neerbyy.com";

#pragma mark -


@implementation NBAPINetworkEngine

#pragma mark - Singleton

+ (instancetype)engine
{
    static dispatch_once_t once_token;
    static NBAPINetworkEngine *engine;
    
    dispatch_once(&once_token, ^{
        engine = [[NBAPINetworkEngine alloc] initWithHostName:kNBAPIHostname];
        [engine registerOperationSubclass:[NBAPINetworkOperation class]];

        MKNetworkEngine *imageEngine = [MKNetworkEngine new];
        [imageEngine useCache];
        [UIImageView setDefaultEngine:imageEngine];
    });
    
    return engine;
}

#pragma mark - Public methods

+ (NBAPINetworkOperation *)operationWithPath:(NSString *)path params:(NSDictionary *)params mainKey:(NSString *)mainKey httpMethod:(NSString *)method
{
    return [self operationWithPath:path params:params mainKey:mainKey image:nil imageKey:nil httpMethod:method];
}

+ (NBAPINetworkOperation *)operationWithPath:(NSString *)path params:(NSDictionary *)params mainKey:(NSString *)mainKey image:(UIImage *)image imageKey:(NSString *)imageKey httpMethod:(NSString *)method
{
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
    } errorHandler:^(NBAPINetworkOperation *operation, NSError *error) {
        NSLog(@"Operation with curl command :\n%@", operation.curlCommandLineString);
        NSLog(@"[FAILED] with response string :\n%@", operation.responseString);
    }];
#endif
    
    return (NBAPINetworkOperation *)operation;
}

@end
