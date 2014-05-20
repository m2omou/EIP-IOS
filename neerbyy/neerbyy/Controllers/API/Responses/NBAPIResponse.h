//
//  NBAPIResponse.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

@class NBUser;
@class NBPlace;
@class NBReportPublication;
@class NBReportComment;
@class NBPublication;
@class NBVote;
@class NBComment;

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

@property (readonly, nonatomic) NBPublication *publication;

@end

@interface NBAPIResponsePlace : NBAPIResponse

@property (readonly, nonatomic) NBPlace *place;

@end


@interface NBAPIResponsePlaceList : NBAPIResponse

@property (readonly, nonatomic) NSArray *places;

@end


@interface NBAPIResponsePublicationList : NBAPIResponse

@property (readonly, nonatomic) NSArray *publications;

@end


@interface NBAPIResponseReportPublication : NBAPIResponse

@property (readonly, nonatomic) NBReportPublication *report;

@end


@interface NBAPIResponseReportComment : NBAPIResponse

@property (readonly, nonatomic) NBReportComment *report;

@end


@interface NBAPIResponseVote : NBAPIResponse

@property (readonly, nonatomic) NBVote *vote;
@property (readonly, nonatomic) NBPublication *publication;

@end


@interface NBAPIResponseComment : NBAPIResponse

@property (readonly, nonatomic) NBComment *comment;

@end


@interface NBAPIResponseCommentList : NBAPIResponse

@property (readonly, nonatomic) NSArray *comments;

@end