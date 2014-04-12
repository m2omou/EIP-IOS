//
//  NBPlace.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 06/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPlace.h"


#pragma mark - Constant values

static NSString * const kNBPlaceIDKey = @"id";
static NSString * const kNBPlaceNameKey = @"name";
static NSString * const kNBPlaceLogintudeKey = @"longitude";
static NSString * const kNBPlaceLatitudeKey = @"latitude";

#pragma mark -


@interface NBPlace ()

@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat latitude;

@end


@implementation NBPlace

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.identifier = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPlaceIDKey];
        self.name = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPlaceNameKey];
        self.longitude = [aDecoder decodeFloatForKey:kNBPlaceLogintudeKey];
        self.latitude = [aDecoder decodeFloatForKey:kNBPlaceLatitudeKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:kNBPlaceIDKey];
    [aCoder encodeObject:self.name forKey:kNBPlaceNameKey];
    [aCoder encodeFloat:self.longitude forKey:kNBPlaceLogintudeKey];
    [aCoder encodeFloat:self.latitude forKey:kNBPlaceLatitudeKey];
}

#pragma mark - Properties

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    return coordinate;
}

@end
