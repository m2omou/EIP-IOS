//
//  NSUserDefaults+NBAdditions.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 10/04/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

@interface NSUserDefaults (NBAdditions)

+ (id)objectForKey:(NSString *)defaultName;
+ (void)setObject:(id)value forKey:(NSString *)defaultName;
+ (void)removeObjectForKey:(NSString *)defaultName;

+ (NSString *)stringForKey:(NSString *)defaultName;
+ (NSArray *)arrayForKey:(NSString *)defaultName;
+ (NSDictionary *)dictionaryForKey:(NSString *)defaultName;
+ (NSData *)dataForKey:(NSString *)defaultName;
+ (NSArray *)stringArrayForKey:(NSString *)defaultName;
+ (NSInteger)integerForKey:(NSString *)defaultName;
+ (float)floatForKey:(NSString *)defaultName;
+ (double)doubleForKey:(NSString *)defaultName;
+ (BOOL)boolForKey:(NSString *)defaultName;
+ (NSURL *)URLForKey:(NSString *)defaultName NS_AVAILABLE(10_6, 4_0);

+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;
+ (void)setFloat:(float)value forKey:(NSString *)defaultName;
+ (void)setDouble:(double)value forKey:(NSString *)defaultName;
+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;
+ (void)setURL:(NSURL *)url forKey:(NSString *)defaultName NS_AVAILABLE(10_6, 4_0);

+ (id)archivedObjectForKey:(NSString *)defaultName;
+ (void)archiveObject:(id)object forKey:(NSString *)defaultName;

@end
