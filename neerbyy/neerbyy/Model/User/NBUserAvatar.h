//
//  NBUserAvatar.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 13/04/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

@interface NBUserAvatar : NSObject <NSCoding>

@property (readonly, nonatomic) NSURL *avatarURL;
@property (readonly, nonatomic) NSURL *thumbnailURL;

@end
