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

static NSString * const kNBPersistanceHasSeenConnectionKey = @"hasSeenConnection";
static NSString * const kNBPersistanceCurrentUserKey = @"currentUser";
static NSString * const kNBPersistanceCurrentPasswordKey = @"currentPassword";

#pragma mark -


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

#pragma mark - Public methods

- (void)logout
{
    _currentUser = nil;
    [NSUserDefaults removeObjectForKey:kNBPersistanceCurrentUserKey];
    [NBKeychain removeObjectForKey:kNBPersistanceCurrentPasswordKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNBNotificationUserLoggedOut object:self];
}

@end
