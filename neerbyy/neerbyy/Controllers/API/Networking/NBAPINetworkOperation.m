//
//  NBNetworkOperation.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import "NBAPINetworkEngine.h"
#import "NBAPINetworkOperation.h"
#import "NBAPIResponse.h"


typedef void (^NBAPINetworkResponseExceptionHandler)(NSException *exception);


@implementation NBAPINetworkOperation

#pragma mark - Public methods

- (void)addCompletionHandler:(NBAPINetworkResponseSuccessHandler)successHandler
                errorHandler:(NBAPINetworkResponseErrorHandler)errorHandler
{
    NBAPINetworkResponseExceptionHandler exceptionHandler;
#ifdef DEBUG
    exceptionHandler = ^(NSException *exception)
    {
        NSLog(@"[EXCEPTION] while parsing the API return : %@", exception);
    };
#endif

    NBAPINetworkResponseSuccessHandler successExceptionWrapper = [self successExceptionWrapper:successHandler exceptionHandler:exceptionHandler];
    NBAPINetworkResponseErrorHandler errorExceptionWrapper = [self errorExceptionWrapper:errorHandler exceptionHandler:exceptionHandler];
    
    [super addCompletionHandler:(MKNKResponseBlock)successExceptionWrapper
                   errorHandler:(MKNKResponseErrorBlock)errorExceptionWrapper];
}

- (void)enqueue
{
    [[NBAPINetworkEngine engine] enqueueOperation:self forceReload:YES];
}

#pragma mark - Properties

- (void)setAPIResponseClass:(Class)APIResponseClass
{
    BOOL isAPIResponseClass = [APIResponseClass isSubclassOfClass:[NBAPIResponse class]];
    NSAssert(isAPIResponseClass, @"Class %@ is not a subclass of NBAPIResponse", NSStringFromClass(APIResponseClass));

    _APIResponseClass = APIResponseClass;
}

- (NBAPIResponse *)APIResponse
{
    return [[self.APIResponseClass alloc] initWithResponseData:self.responseJSON];
}

#pragma mark - Private methods - Exception wrappers

- (NBAPINetworkResponseSuccessHandler)successExceptionWrapper:(NBAPINetworkResponseSuccessHandler)successHandler
                                          exceptionHandler:(NBAPINetworkResponseExceptionHandler)exceptionHandler
{
    NBAPINetworkResponseSuccessHandler exceptionWrapper = ^(NBAPINetworkOperation *operation)
    {
        @try {
            if (successHandler)
                successHandler(operation);
        } @catch (NSException *exception) {
            if (exceptionHandler)
                exceptionHandler(exception);
        }
    };
    
    return exceptionWrapper;
}

- (NBAPINetworkResponseErrorHandler)errorExceptionWrapper:(NBAPINetworkResponseErrorHandler)errorHandler
                                      exceptionHandler:(NBAPINetworkResponseExceptionHandler)exceptionHandler
{
    NBAPINetworkResponseErrorHandler exceptionWrapper = ^(NBAPINetworkOperation *operation, NSError *error)
    {
        @try {
            if (errorHandler)
                errorHandler(operation, error);
        } @catch (NSException *exception) {
            if (exceptionHandler)
                exceptionHandler(exception);
        }
    };
    
    return exceptionWrapper;
}

@end
