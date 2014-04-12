//
//  NBAnnotationView.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 06/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface NBPlaceAnnotationView : MKAnnotationView

- (void)showCalloutWithAction:(void (^)(MKAnnotationView *))onCalloutTap;
- (void)hideCallout;

@end
