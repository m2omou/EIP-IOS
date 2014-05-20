//
//  NBPersistanceManagerTests.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 16/04/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "NBPersistanceManager.h"
#import "NBUser.h"

SPEC_BEGIN(NBPersistanceManagerTests)

describe(@"Creating and getting NBPersistanceManager", ^{

    it(@"should be a signleton", ^{
       NBPersistanceManager *manager = [NBPersistanceManager sharedManager];
       NBPersistanceManager *secondManager = [NBPersistanceManager sharedManager];
       
       [[manager should] equal:secondManager];
   });

});

describe(@"Storing the current user", ^{
//    [NSUserDefaults resetStandardUserDefaults];
//    
//    __block NBPersistanceManager *manager = [NBPersistanceManager sharedManager];
//    
//    __block NSNumber *identifier = @42;
//    __block NSString *username = @"foo";
//    __block NSString *firstname = @"bar";
//    __block NSString *lastname = @"baz";
//    __block NSString *email = @"foo@bar.baz";
//    __block NBUser *user = [NBUser new];
//    user.identifier = identifier;
//    user.username = username;
//    user.firstname = firstname;
//    user.lastname = lastname;
//    user.email = email;
//    
//    __block NSString *password = @"foo";
//    
//    it(@"shouldn't contain a user by default", ^{
//        [[manager.currentUser should] beNil];
//        [[manager.currentUserPassword should] beNil];
//        [[theValue(manager.isConnected) should] equal:theValue(NO)];
//    });
//    
//    it(@"should store the current user", ^{
//        manager.currentUser = user;
//        manager.currentUserPassword = password;
//        
//        [[manager.currentUser shouldNot] beNil];
//        [[manager.currentUser.identifier should] equal:identifier];
//        [[manager.currentUser.username should] equal:username];
//        [[manager.currentUser.firstname should] equal:firstname];
//        [[manager.currentUser.lastname should] equal:lastname];
//        [[manager.currentUser.email should] equal:email];
//        [[manager.currentUserPassword should] equal:password];
//        [[theValue(manager.isConnected) should] equal:theValue(YES)];
//    });
//    
//    it(@"should remove the current user on logout", ^{
//        [manager logout];
//        
//        [[manager.currentUser should] beNil];
//        [[manager.currentUserPassword should] beNil];
//        [[theValue(manager.isConnected) should] equal:theValue(NO)];
//    });
//    
//    [NSUserDefaults resetStandardUserDefaults];
});

//describe(@"Sending notifications", ^{
//    [NSUserDefaults resetStandardUserDefaults];
//    
//    __block NBPersistanceManager *manager = [NBPersistanceManager sharedManager];
//    __block NBUser *user = [NBUser new];
//
//    it(@"should send notifications on login", ^{
//        
//    });
//    
//    it(@"should send notifications on logout", ^{
//        
//    });
//    
//});

SPEC_END