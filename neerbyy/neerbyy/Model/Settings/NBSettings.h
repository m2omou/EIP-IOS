//
//  NBSettings.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 26/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBSettings : NSObject <NSCoding>

@property (strong, nonatomic) NSNumber *identifier;
@property (assign, nonatomic) BOOL canBeContactedByOtherUsers;
@property (assign, nonatomic) BOOL receivesNotificationOnComments;
@property (assign, nonatomic) BOOL receivesNotificationOnMessages;

- (NSDictionary *)toDictionary;

@end
