//
//  TLAPIResponse.h
//  OrangeTV
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

@class NBUser;


@interface NBAPIResponse : NSObject

- (instancetype)initWithResponseData:(id)data;

@property (assign, nonatomic) NSInteger responseCode;
@property (strong, nonatomic) NSString *responseMessage;
@property (readonly, nonatomic) BOOL hasError;

@end


@interface NBAPIResponseLogin : NBAPIResponse

@property (readonly, nonatomic) NBUser *user;

@end


@interface NBAPIResponseRegister : NBAPIResponse

@property (readonly, nonatomic) NBUser *user;

@end


@interface NBAPIResponsePlaceList : NBAPIResponse

@property (readonly, nonatomic) NSArray *places;

@end