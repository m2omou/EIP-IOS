//
//  NBPersistanceManager.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 11/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPersistanceManager.h"
#import "NBUser.h"

#pragma mark - Constants

static NSString * const kNBPersistanceHasSeenConnectionKey = @"hasSeenConnection";
static NSString * const kNBPersistanceCurrentUserKey = @"currentUser";

NSString * const kNBNotificationUserLoggedIn = @"userLoggedIn";
NSString * const kNBNotificationUserLoggedOut = @"userLoggedOut";

#pragma mark -


@interface NBPersistanceManager ()

@property (readonly, nonatomic) NSUserDefaults *database;
- (void)saveDatabase;

@end


@implementation NBPersistanceManager

#pragma mark - Public methods

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
    {
        NSDictionary *currentUserDic = [[self database] dictionaryForKey:kNBPersistanceCurrentUserKey];
        if (currentUserDic == nil)
            return nil;

        NBUser *currentUser = [NBUser modelWithDictionary:currentUserDic];
        _currentUser = currentUser;
    }
    return _currentUser;
}

- (void)setCurrentUser:(NBUser *)currentUser
{
    _currentUser = currentUser;

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSUserDefaults *database = [self database];
    if (currentUser)
    {
        NSDictionary *currentUserDic = [currentUser dictionaryWithModel];
        [database setObject:currentUserDic forKey:kNBPersistanceCurrentUserKey];
        [notificationCenter postNotificationName:kNBNotificationUserLoggedIn object:self];
    }
    else
    {
        [database removeObjectForKey:kNBPersistanceCurrentUserKey];
        [notificationCenter postNotificationName:kNBNotificationUserLoggedOut object:self];
    }
    [self saveDatabase];
}

- (BOOL)isConnected
{
    NBUser *user = self.currentUser;
    BOOL isConnected = (user != nil);
    return isConnected;
}

#pragma mark - Private methods

- (NSUserDefaults *)database
{
    NSUserDefaults *database = [NSUserDefaults standardUserDefaults];
    return database;
}

- (void)saveDatabase
{
    [[self database] synchronize];
}

@end
