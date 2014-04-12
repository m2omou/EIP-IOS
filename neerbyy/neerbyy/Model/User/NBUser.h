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
@property (strong, nonatomic) NSString *avatarURL;

@end
