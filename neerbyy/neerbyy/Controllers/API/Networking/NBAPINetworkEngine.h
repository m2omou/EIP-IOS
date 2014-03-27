//
//  NBEngine.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import "MKNetworkEngine.h"
@class NBAPINetworkOperation;


@interface NBAPINetworkEngine : MKNetworkEngine

+ (instancetype)engine;

- (NBAPINetworkOperation *)operationWithPath:(NSString *)path params:(NSDictionary *)body httpMethod:(NSString *)method;

@end
