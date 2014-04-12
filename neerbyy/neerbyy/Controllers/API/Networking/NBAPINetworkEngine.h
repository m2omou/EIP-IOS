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

+ (NBAPINetworkOperation *)operationWithPath:(NSString *)path params:(NSDictionary *)params mainKey:(NSString *)mainKey httpMethod:(NSString *)method;
+ (NBAPINetworkOperation *)operationWithPath:(NSString *)path params:(NSDictionary *)params mainKey:(NSString *)mainKey image:(UIImage *)image imageKey:(NSString *)imageKey httpMethod:(NSString *)method;

@end
