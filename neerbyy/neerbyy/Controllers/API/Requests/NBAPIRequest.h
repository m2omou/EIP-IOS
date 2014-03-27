//
//  NBAPIRequest.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import <MapKit/MapKit.h>
@class NBAPINetworkOperation;


#pragma mark - Constants

extern NSString * const kNBAPIUserKey;
extern NSString * const kNBAPIUserIDKey;
extern NSString * const kNBAPIUserUsernameKey;
extern NSString * const kNBAPIUserFirsnameKey;
extern NSString * const kNBAPIUserLastnameKey;
extern NSString * const kNBAPIUserEmailKey;
extern NSString * const kNBAPIUserPasswordKey;
extern NSString * const kNBAPIUserAvatarKey;

extern NSString * const kNBAPIPlaceIDKey;
extern NSString * const kNBAPIPlaceNameKey;
extern NSString * const kNBAPIPlaceLongitudeKey;
extern NSString * const kNBAPIPlaceLatitudeKey;

#pragma mark -


@interface NBAPIRequest : NSObject

+ (NBAPINetworkOperation *)imageWithPath:(NSString *)imagePath;

+ (NBAPINetworkOperation *)loginWithUsername:(NSString *)username
                                    password:(NSString *)password;

+ (NBAPINetworkOperation *)registerWithUsername:(NSString *)username
                                       password:(NSString *)password
                                          email:(NSString *)email
                                         avatar:(UIImage *)avatar;

+ (NBAPINetworkOperation *)sendForgetPasswordWithEmail:(NSString *)email;

+ (NBAPINetworkOperation *)fetchPlacesAroundCoordinate:(CLLocationCoordinate2D)coordinate
                                             withLimit:(NSNumber *)limit;

@end
