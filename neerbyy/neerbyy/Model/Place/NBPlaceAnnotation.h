//
//  NBPlaceAnnotation.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 07/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPlace.h"

@interface NBPlaceAnnotation : NSObject <MKAnnotation>

- (instancetype)initWithPlace:(NBPlace *)place;

@property (strong, nonatomic) NBPlace *place;

@property (strong, nonatomic) NSString *identifier;
@property (copy,   nonatomic) NSString *title;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@end
