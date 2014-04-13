//
//  NBPublication.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 13/04/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

typedef enum {
    kNBPublicationTypeUnknown,
    kNBPublicationTypeImage,
    kNBPublicationTypeLink,
} NBPublicationType;


@interface NBPublication : NSObject <NSCoding>

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSNumber *placeId;
@property (strong, nonatomic) NSString *description;
@property (readonly, nonatomic) NBPublicationType type;
@property (readonly, nonatomic) NSURL *contentURL;
@property (readonly, nonatomic) NSURL *thumbnailURL;
@property (strong, nonatomic) NSNumber *numberOfComments;
@property (strong, nonatomic) NSNumber *numberOfLikes;
@property (strong, nonatomic) NSNumber *numberOfDislikes;

@end
