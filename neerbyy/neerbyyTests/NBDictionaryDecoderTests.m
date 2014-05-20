//
//  NBDictionaryDecoderTests.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 16/04/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//


#import <Kiwi/Kiwi.h>

#import "NBDictionaryDecoder.h"

SPEC_BEGIN(NBDictionaryDecoderTests)

describe(@"using NBDictionaryDecoder", ^{
    __block NSString *objectKey = @"object";
    __block id object = [NSObject new];

    __block NSString *stringKey = @"string";
    __block NSString *string = @"Some string";

    __block NSString *numberKey = @"number";
    __block NSNumber *number = @42;

    __block NSString *dictionaryKey = @"dictionary";
    __block NSDictionary *dictionary = @{};

    __block NSString *arrayKey = @"array";
    __block NSArray *array = @[];

    __block NSDictionary *data = @{objectKey: object,
                                   stringKey: string,
                                   numberKey: number,
                                   dictionaryKey: dictionary,
                                   arrayKey: array};
    __block NBDictionaryDecoder *decoder = [NBDictionaryDecoder dictonaryCoderWithData:data];
    
    it(@"should return correct values", ^{
        [[[decoder decodeObjectForKey:objectKey] should] equal:object];
        [[[decoder decodeObjectForKey:stringKey] should] equal:string];
        [[[decoder decodeObjectForKey:numberKey] should] equal:number];
        [[[decoder decodeObjectForKey:dictionaryKey] should] equal:dictionary];
        [[[decoder decodeObjectForKey:arrayKey] should] equal:array];
    });
    
    it(@"shouldn't return instances of another class", ^{
        [[[decoder decodeObjectOfClass:[NSNumber class] forKey:stringKey] should] beNil];
    });
});

SPEC_END