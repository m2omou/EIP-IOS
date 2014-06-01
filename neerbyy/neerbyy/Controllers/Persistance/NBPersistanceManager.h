//
//  NBPersistanceManager.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 11/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

@class NBUser;

#import <MapKit/MapKit.h>

#pragma mark - Constants

extern NSString * const kNBNotificationUserLoggedIn;
extern NSString * const kNBNotificationUserLoggedOut;

#pragma mark -


@interface NBPersistanceManager : NSObject

+ (instancetype)sharedManager;

@property (strong, nonatomic) NBUser *currentUser;
@property (strong, nonatomic) NSString *currentUserPassword;
@property (readonly, nonatomic) BOOL isConnected;
@property (assign, nonatomic) CLLocationCoordinate2D lastKnownLocation;

- (void)logout;

@end
