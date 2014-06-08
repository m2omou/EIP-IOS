//
//  NBPersistanceManager.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 11/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPersistanceManager.h"
#import "NSUserDefaults+NBAdditions.h"
#import "NBUser.h"
#import "NBKeychain.h"

#pragma mark - Constants

NSString * const kNBNotificationUserLoggedIn = @"userLoggedIn";
NSString * const kNBNotificationUserLoggedOut = @"userLoggedOut";

static NSString * const kNBPersistanceCurrentUserKey = @"currentUser";
static NSString * const kNBPersistanceCurrentPasswordKey = @"currentPassword";
static NSString * const kNBPersistanceTutorialKey = @"seenTutorial";

#pragma mark -

@interface NBPersistanceManager ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end


@implementation NBPersistanceManager

#pragma mark - Singleton

+ (instancetype)sharedManager
{
    static id sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self class] new];
    });
    return sharedManager;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.locationManager = [CLLocationManager new];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    return self;
}

#pragma mark - Properties

@synthesize currentUser = _currentUser;
- (NBUser *)currentUser
{
    if (_currentUser == nil)
        _currentUser = [NSUserDefaults archivedObjectForKey:kNBPersistanceCurrentUserKey];
    
    return _currentUser;
}

- (void)setCurrentUser:(NBUser *)currentUser
{
    if (!currentUser)
        [self logout];
    else
    {
        [NSUserDefaults archiveObject:currentUser forKey:kNBPersistanceCurrentUserKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNBNotificationUserLoggedIn object:self];
        _currentUser = currentUser;
    }
}

- (void)setCurrentUserPassword:(NSString *)currentUserPassword
{
    [NBKeychain setObject:currentUserPassword forKey:kNBPersistanceCurrentPasswordKey];
}

- (NSString *)currentUserPassword
{
    NSString *password = [NBKeychain objectForKey:kNBPersistanceCurrentPasswordKey];
    return password;
}

- (BOOL)isConnected
{
    NBUser *user = self.currentUser;
    BOOL isConnected = (user != nil);
    return isConnected;
}

- (CLLocationCoordinate2D)lastKnownLocation
{
    if (self.locationManager.location == nil)
        return kCLLocationCoordinate2DInvalid;
    
    return self.locationManager.location.coordinate;
}

- (void)setHasSeenTutorial:(BOOL)hasSeenTutorial
{
    [NSUserDefaults setBool:hasSeenTutorial forKey:kNBPersistanceTutorialKey];
}

- (BOOL)hasSeenTutorial
{
    return [NSUserDefaults boolForKey:kNBPersistanceTutorialKey];
}

#pragma mark - Public methods

- (void)logout
{
    _currentUser = nil;
    [NSUserDefaults removeObjectForKey:kNBPersistanceCurrentUserKey];
    [NBKeychain removeObjectForKey:kNBPersistanceCurrentPasswordKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNBNotificationUserLoggedOut object:self];
}

@end
