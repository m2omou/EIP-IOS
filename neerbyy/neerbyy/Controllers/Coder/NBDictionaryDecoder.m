//
//  NBDictionaryCoder.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 07/04/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import "NBDictionaryDecoder.h"


@interface NBDictionaryDecoder ()

@property (strong, nonatomic) NSDictionary *data;

@end


@implementation NBDictionaryDecoder

#pragma mark - Initialisation

+ (instancetype)dictonaryCoderWithData:(NSDictionary *)data
{
    NBDictionaryDecoder *dictionaryCoder = [NBDictionaryDecoder new];
    dictionaryCoder.data = data;
    return dictionaryCoder;
}

#pragma mark - NSCoder

- (id)decodeObjectForKey:(NSString *)key
{
    id data = self.data[key];
    
    if ([data isEqual:[NSNull null]])
        return nil;
    return data;
}

- (float)decodeFloatForKey:(NSString *)key
{
    return [[self decodeObjectForKey:key] floatValue];
}

- (BOOL)allowsKeyedCoding
{
    return YES;
}

@end
