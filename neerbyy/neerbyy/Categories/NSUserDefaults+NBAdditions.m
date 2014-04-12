//
//  NSUserDefaults+NBAdditions.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 10/04/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import "NSUserDefaults+NBAdditions.h"

@implementation NSUserDefaults (NBAdditions)

+ (id)objectForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeObjectForKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)stringForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:defaultName];
}

+ (NSArray *)arrayForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:defaultName];
}

+ (NSDictionary *)dictionaryForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:defaultName];
}

+ (NSData *)dataForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] dataForKey:defaultName];
}

+ (NSArray *)stringArrayForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] stringArrayForKey:defaultName];
}

+ (NSInteger)integerForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
}

+ (float)floatForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:defaultName];
}

+ (double)doubleForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:defaultName];
}

+ (BOOL)boolForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}

+ (NSURL *)URLForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] URLForKey:defaultName];
}

+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setFloat:(float)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setDouble:(double)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setURL:(NSURL *)url forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setURL:url forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)archivedObjectForKey:(NSString *)defaultName
{
    NSData *data = [NSUserDefaults dataForKey:defaultName];
    if (!data)
        return nil;

    id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return object;
}

+ (void)archiveObject:(id)object forKey:(NSString *)defaultName
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    if (!data)
        return ;

    [NSUserDefaults setObject:data forKey:defaultName];
}


@end
