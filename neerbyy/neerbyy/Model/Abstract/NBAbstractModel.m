//
//  NBAbstractModel.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 01/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBAbstractModel.h"


@implementation NBAbstractModel

#pragma mark - Initialisation

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
        [self setValuesForKeysWithDictionary:dictionary];
    
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

#pragma mark - Public methods

- (id)data:(id)data ofType:(Class)class
{
    if ([data isEqual:[NSNull null]] ||
        [data isKindOfClass:class] == NO)
        return nil;

    return data;
}

- (NSDictionary *)dictionaryWithModel
{
    NSAssert(NO, @"You need to subclass this method before using it");
    return @{};
}

#pragma mark - NSKeyValueCoding

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"Setting value : [%@] for undefined key : [%@]", value, key);
}

@end
