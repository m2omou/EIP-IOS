//
//  NBPlace.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 06/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPlace.h"


#pragma mark - Constant values

static NSString * const kNBPlaceKeyID = @"id";
static NSString * const kNBPlaceKeyName = @"name";
static NSString * const kNBPlaceKeyLogintude = @"longitude";
static NSString * const kNBPlaceKeyLatitude = @"latitude";
static NSString * const kNBPlaceKeyAddress = @"address";
static NSString * const kNBPlaceKeyPostCode = @"postcode";
static NSString * const kNBPlaceKeyCity = @"city";
static NSString * const kNBPlaceKeyCountry = @"country";
static NSString * const kNBPlaceKeyIconURL = @"icon";
static NSString * const kNBPlaceKeyFollowingId = @"followed_place_id";
static NSString * const kNBPlaceKeyDistance = @"distance";
static NSString * const kNBPlaceKeyDistanceBoundary = @"distance_boundary";
static NSString * const kNBPlaceKeyCurrentUserCanPublish = @"can_publish";

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
        self.identifier = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPlaceKeyID];
        self.name = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPlaceKeyName];
        self.longitude = [aDecoder decodeFloatForKey:kNBPlaceKeyLogintude];
        self.latitude = [aDecoder decodeFloatForKey:kNBPlaceKeyLatitude];
        self.address = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPlaceKeyAddress];
        self.postCode = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPlaceKeyPostCode];
        self.city = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPlaceKeyCity];
        self.country = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPlaceKeyCountry];
        self.iconURL = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBPlaceKeyIconURL];
        self.followingId = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPlaceKeyFollowingId];
        self.distance = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPlaceKeyDistance];
        self.distanceBoundary = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBPlaceKeyDistanceBoundary];
        self.currentUserCanPublish = [aDecoder decodeBoolForKey:kNBPlaceKeyCurrentUserCanPublish];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:kNBPlaceKeyID];
    [aCoder encodeObject:self.name forKey:kNBPlaceKeyName];
    [aCoder encodeFloat:self.longitude forKey:kNBPlaceKeyLogintude];
    [aCoder encodeFloat:self.latitude forKey:kNBPlaceKeyLatitude];
    [aCoder encodeObject:self.address forKey:kNBPlaceKeyAddress];
    [aCoder encodeObject:self.postCode forKey:kNBPlaceKeyPostCode];
    [aCoder encodeObject:self.city forKey:kNBPlaceKeyCity];
    [aCoder encodeObject:self.iconURL forKey:kNBPlaceKeyIconURL];
    [aCoder encodeObject:self.followingId forKey:kNBPlaceKeyFollowingId];
    [aCoder encodeObject:self.distance forKey:kNBPlaceKeyDistance];
    [aCoder encodeObject:self.distanceBoundary forKey:kNBPlaceKeyDistanceBoundary];
    [aCoder encodeBool:self.currentUserCanPublish forKey:kNBPlaceKeyCurrentUserCanPublish];
}

#pragma mark - Properties

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    return coordinate;
}

- (BOOL)isFollowedByCurrentUser
{
    return self.followingId != nil;
}

@end
