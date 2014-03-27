//
//  NBPlaceAnnotation.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 07/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPlaceAnnotation.h"

@implementation NBPlaceAnnotation

- (instancetype)initWithPlace:(NBPlace *)place
{
    self = [super init];
    
    if (self)
    {
        self.place = place;
        self.identifier = place.identifier;
        self.title = place.name;
        self.coordinate = place.coordinate;
    }
    
    return self;
}

@end
