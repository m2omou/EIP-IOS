//
//  NBPlace.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 06/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface NBPlace : NSObject <NSCoding>

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *name;
@property (readonly, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *postCode;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *iconURL;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) NSNumber *distanceBoundary;
@property (assign, nonatomic) BOOL currentUserCanPublish;

@property (readonly, nonatomic) BOOL isFollowedByCurrentUser;
@property (strong, nonatomic) NSNumber *followingId;

@end
