//
//  NBNetworkOperation.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import "MKNetworkOperation.h"
@class NBAPIResponse;
@class NBAPINetworkOperation;


typedef void (^NBAPINetworkResponseSuccessHandler)(NBAPINetworkOperation *operation);
typedef void (^NBAPINetworkResponseErrorHandler)(NBAPINetworkOperation *operation, NSError *error);


@interface NBAPINetworkOperation : MKNetworkOperation

+ (NBAPINetworkResponseErrorHandler)defaultErrorHandler;

@property (readonly, nonatomic) NBAPIResponse *APIResponse;
@property (strong, nonatomic) Class APIResponseClass;

- (void)addCompletionHandler:(NBAPINetworkResponseSuccessHandler)completionHandler errorHandler:(NBAPINetworkResponseErrorHandler)errorHandler;
- (void)enqueue;

@end
