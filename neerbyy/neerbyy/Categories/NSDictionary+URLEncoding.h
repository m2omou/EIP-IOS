//
//  NSDictionary+URLEncoding.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 11/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

@interface NSDictionary (URLEncoding)

- (NSDictionary *)encodeNestedDictionaryWithPrefix:(NSString *)keyPrefix;

@end
