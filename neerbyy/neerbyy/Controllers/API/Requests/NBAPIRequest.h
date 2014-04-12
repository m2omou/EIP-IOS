//
//  NBAPIRequest.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import <MapKit/MapKit.h>
@class NBAPINetworkOperation;


@interface NBAPIRequest : NSObject

+ (NBAPINetworkOperation *)loginWithUsername:(NSString *)username password:(NSString *)password;
+ (NBAPINetworkOperation *)registerWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email avatar:(UIImage *)avatar;
+ (NBAPINetworkOperation *)sendForgetPasswordWithEmail:(NSString *)email;

+ (NBAPINetworkOperation *)fetchPlacesAroundCoordinate:(CLLocationCoordinate2D)coordinate;
+ (NBAPINetworkOperation *)fetchPublicationsForPlace:(NSString *)placeIdentifier;

+ (NBAPINetworkOperation *)createPublicationOnPlace:(NSString *)placeIdentifier withImage:(UIImage *)image description:(NSString *)description;

@end
