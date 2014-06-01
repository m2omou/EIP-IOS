//
//  NBPublication.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 13/04/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import <MapKit/MapKit.h>

typedef NS_ENUM(NSUInteger, NBPublicationType) {
    kNBPublicationTypeLink,
    kNBPublicationTypeText,
    kNBPublicationTypeImage,
    kNBPublicationTypeYoutube,
    kNBPublicationTypeFile,
    kNBPublicationTypeUnknown
};

@class NBVote;
@class NBUser;

@interface NBPublication : NSObject <NSCoding>

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSNumber *placeId;
@property (readonly, nonatomic) CLLocationCoordinate2D coordinate;
@property (readonly, nonatomic) NBPublicationType type;
@property (strong, nonatomic) NSString *contentDescription;
@property (readonly, nonatomic) NSURL *contentURL;
@property (readonly, nonatomic) NSURL *thumbnailURL;
@property (strong, nonatomic) NSNumber *numberOfComments;
@property (strong, nonatomic) NSNumber *numberOfUpvotes;
@property (strong, nonatomic) NSNumber *numberOfDownvotes;
@property (strong, nonatomic) NBVote *voteOfCurrentUser;
@property (readonly, nonatomic) NBUser *author;

@end
