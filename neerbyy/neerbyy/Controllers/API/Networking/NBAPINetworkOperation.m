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

+ (NBAPINetworkResponseErrorHandler)defaultErrorHandler
{
    return ^(NBAPINetworkOperation *operation, NSError *error) {
        NBAPIResponse *response = operation.APIResponse;
        NSString *message = ((response.responseMessage ?: error.localizedDescription) ?: @"Une erreur inconnue s'est produite !");
        [[[UIAlertView alloc] initWithTitle:@"Oups !"
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:@"Annuler"
                          otherButtonTitles:nil] show];
    };
}

- (void)addCompletionHandler:(NBAPINetworkResponseSuccessHandler)successHandler
                errorHandler:(NBAPINetworkResponseErrorHandler)errorHandler
{
    NBAPINetworkResponseExceptionHandler exceptionHandler = ^(NSException *exception)
    {
#ifdef DEBUG
        NSLog(@"[EXCEPTION] while parsing the API return : %@", exception);
#endif
    };
    
    [super addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NBAPINetworkOperation *nbOperation = (NBAPINetworkOperation *)completedOperation;
        NBAPIResponse *response = nbOperation.APIResponse;
        
        @try {
            if (response.hasError)
                errorHandler(nbOperation, nil);
            else
                successHandler(nbOperation);
        } @catch (NSException *exception) {
            exceptionHandler(exception);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        @try {
            errorHandler((NBAPINetworkOperation *)completedOperation, error);
        } @catch (NSException *exception) {
            exceptionHandler(exception);
        }
    }];
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

@end
