//
//  TLAPIResponse.m
//  OrangeTV
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import "NBAPIResponse.h"
#import "NBPlace.h"
#import "NBUser.h"


#pragma mark - Constants

static NSString * const kNBAPIResponseCodeKey = @"responseCode";
static NSString * const kNBAPIResponseMessageKey = @"responseMessage";
static NSString * const kNBAPIResponseResultKey = @"result";
static NSInteger  const kNBAPIResponseCodeSuccess = 0;

static NSString * const kNBAPIResponseUserKey = @"user";
static NSString * const kNBAPIReponsePlaceListKey = @"places";

#pragma mark -


@interface NBAPIResponse ()

@property (strong, nonatomic) NSDictionary *data;

@end


@implementation NBAPIResponse

#pragma mark - Initialisation

- (id)initWithResponseData:(NSDictionary *)data
{
    self = [super init];

    if (self)
    {
        if ([data isKindOfClass:[NSDictionary class]])
        {
            id responseCode = data[kNBAPIResponseCodeKey];
            if ([responseCode isKindOfClass:[NSNumber class]])
                self.responseCode = [responseCode integerValue];
            
            id responseMessage = data[kNBAPIResponseMessageKey];
            if ([responseMessage isKindOfClass:[NSString class]])
                self.responseMessage = responseMessage;
            
            id responseResult = data[kNBAPIResponseResultKey];
            if ([responseResult isKindOfClass:[NSDictionary class]])
                self.data = responseResult;
            else
                self.data = [NSDictionary dictionary];
        }
        else
        {
            self.data = [NSDictionary dictionary];
        }
    }

    return self;
}

#pragma mark - Public methods

- (id)dataWithKey:(NSString *)key ofType:(Class)class
{
    id data = self.data[key];

    if ([data isEqual:[NSNull null]] || [data isKindOfClass:class] == NO)
        return nil;
    return data;
}

#pragma mark - Properties

- (BOOL)hasError
{
    BOOL hasError = self.responseCode != kNBAPIResponseCodeSuccess;
    return hasError;
}

@end


#pragma mark - Login

@implementation NBAPIResponseLogin

- (NBUser *)user
{
    NSDictionary *rawUser = [self dataWithKey:kNBAPIResponseUserKey ofType:[NSDictionary class]];
    if (rawUser == nil)
        return nil;
    
    NBUser *user = [NBUser modelWithDictionary:rawUser];
    return user;
}

@end


#pragma mark - Register

@implementation NBAPIResponseRegister

- (NBUser *)user
{
    NBUser *user = [NBUser modelWithDictionary:self.data];
    return user;
}

@end


#pragma mark - Places

@implementation NBAPIResponsePlaceList

- (NSArray *)places
{
    NSArray *rawPlaces = [self dataWithKey:kNBAPIReponsePlaceListKey ofType:[NSArray class]];

    NSMutableArray *places = [NSMutableArray array];
    for (NSDictionary *rawPlace in rawPlaces)
    {
        NBPlace *place = [NBPlace modelWithDictionary:rawPlace];
        [places addObject:place];
    }

    return [places copy];
}

@end