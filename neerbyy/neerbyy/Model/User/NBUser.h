//
//  NBUser.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 01/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

@interface NBUser : NSObject <NSCoding>

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *firstname;
@property (strong, nonatomic) NSString *lastname;
@property (strong, nonatomic) NSString *email;
@property (readonly, nonatomic) NSURL *avatarURL;
@property (readonly, nonatomic) NSURL *avatarThumbnailURL;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSNumber *settingsID;

- (BOOL)isEqualToUser:(NBUser *)user;

@end
