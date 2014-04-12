//
//  NBKeychain.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 12/04/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

@interface NBKeychain : NSObject

+ (void)setObject:(id)object forKey:(NSString*)key;
+ (id)objectForKey:(NSString*)key;
+ (void)removeObjectForKey:(NSString *)key;

@end
