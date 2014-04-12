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

@end
