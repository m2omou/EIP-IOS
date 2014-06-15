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
extern NSString * const kNBNotificationPlaceFollowed;
extern NSString * const kNBNotificationPlaceUnfollowed;

#pragma mark -


@interface NBPersistanceManager : NSObject

+ (instancetype)sharedManager;

@property (readonly, nonatomic) BOOL isConnected;
@property (strong, nonatomic) NBUser *currentUser;
@property (strong, nonatomic) NSString *currentUserPassword;

@property (readonly, nonatomic) CLLocationCoordinate2D lastKnownLocation;

@property (assign, nonatomic) BOOL hasSeenTutorial;

- (void)logout;

@end
