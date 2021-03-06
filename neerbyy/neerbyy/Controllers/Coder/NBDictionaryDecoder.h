//
//  NBDictionaryCoder.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 07/04/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

@interface NBDictionaryDecoder : NSCoder

+ (instancetype)dictonaryCoderWithData:(NSDictionary *)data;

- (id)decodeObjectForKey:(NSString *)key;
- (id)decodeObjectOfClass:(Class)aClass forKey:(NSString *)key;
- (float)decodeFloatForKey:(NSString *)key;
- (BOOL)decodeBoolForKey:(NSString *)key;

@end

