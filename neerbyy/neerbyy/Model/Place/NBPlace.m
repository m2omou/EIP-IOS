//
//  NBPlace.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 06/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPlace.h"


@interface NBPlace ()

@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat latitude;

@end


@implementation NBPlace

#pragma mark - NSKeyValueCoding

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:kNBAPIPlaceIDKey])
        self.identifier = [self data:value ofType:[NSString class]];
    else if ([key isEqualToString:kNBAPIPlaceNameKey])
        self.name = [self data:value ofType:[NSString class]];
    else if ([key isEqualToString:kNBAPIPlaceLongitudeKey])
        self.longitude = [[self data:value ofType:[NSNumber class]] doubleValue];
    else if ([key isEqualToString:kNBAPIPlaceLatitudeKey])
        self.latitude = [[self data:value ofType:[NSNumber class]] doubleValue];
}

#pragma mark - Properties

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    return coordinate;
}

@end
