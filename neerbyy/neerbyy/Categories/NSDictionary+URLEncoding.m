//
//  NSDictionary+URLEncoding.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 11/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NSDictionary+URLEncoding.h"


@implementation NSDictionary (URLEncoding)

- (NSDictionary *)encodeNestedDictionaryWithPrefix:(NSString *)keyPrefix
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (__strong NSString *key in self)
    {
        id value = [self objectForKey:key];
        if (keyPrefix)
            key = [keyPrefix stringByAppendingFormat:@"[%@]", key];
        if ([value isKindOfClass:[NSDictionary class]])
            [result addEntriesFromDictionary:[value encodeNestedDictionaryWithPrefix:key]];
        else
            result[key] = value;
    }
    return [NSDictionary dictionaryWithDictionary:result];
}

@end
