//
//  NBEngine.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import "NBAPINetworkEngine.h"
#import "NBAPINetworkOperation.h"


#pragma mark - Constants

static NSString * const kNBAPIHostname = @"neerbyy.com";
static NSUInteger const kNBAPIPort = 80;

#pragma mark -


@implementation NBAPINetworkEngine

#pragma mark - Public methods

+ (instancetype)engine
{
    static dispatch_once_t once_token;
    static NBAPINetworkEngine *engine;
    
    dispatch_once(&once_token, ^{
        engine = [[NBAPINetworkEngine alloc] initWithHostName:kNBAPIHostname];
        engine.portNumber = kNBAPIPort;
        [engine registerOperationSubclass:[NBAPINetworkOperation class]];
    });
    
    return engine;
}

- (NBAPINetworkOperation *)operationWithPath:(NSString *)path params:(NSDictionary *)body httpMethod:(NSString *)method
{
    NBAPINetworkOperation *operation = (NBAPINetworkOperation *)[super operationWithPath:path params:body httpMethod:method];
    
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
