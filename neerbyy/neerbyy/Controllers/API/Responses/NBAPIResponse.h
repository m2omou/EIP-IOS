//
//  NBAPIResponse.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

@class NBUser;


@interface NBAPIResponse : NSObject

- (instancetype)initWithResponseData:(NSDictionary *)data;

@property (assign, nonatomic) NSInteger responseCode;
@property (strong, nonatomic) NSString *responseMessage;
@property (readonly, nonatomic) BOOL hasError;

@end


@interface NBAPIResponseUser : NBAPIResponse

@property (readonly, nonatomic) NBUser *user;

@end


@interface NBAPIResponsePublication : NBAPIResponse

@property (readonly, nonatomic) id publication;

@end


@interface NBAPIResponsePlaceList : NBAPIResponse

@property (readonly, nonatomic) NSArray *places;

@end


@interface NBAPIResponsePublicationList : NBAPIResponse

@property (readonly, nonatomic) NSArray *publications;

@end