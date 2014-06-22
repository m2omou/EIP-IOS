//
//  NSString+DataFormatting.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 01/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NSString+DataFormatting.h"

@implementation NSString (DataFormatting)

+ (NSString *)stringForDistance:(CLLocationDistance)distance prefix:(NSString *)prefix
{
    if (distance == CLLocationDistanceMax)
        return @"Distance indéterminée";
    
    NSString *distanceUnit;
    if (distance > 1000)
        distanceUnit = @"km";
    else
        distanceUnit = @"m";

    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.minimumIntegerDigits = 1;
    numberFormatter.minimumFractionDigits = 1;
    numberFormatter.maximumFractionDigits = 2;
    numberFormatter.decimalSeparator = @",";
    
    NSString *distanceString = [numberFormatter stringFromNumber:@(distance)];
    return [NSString stringWithFormat:@"%@%@ %@", prefix, distanceString, distanceUnit];
}

+ (NSString *)stringForDate:(NSDate *)date
{
    if (date == nil)
        return @"Date indéterminée";
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.doesRelativeDateFormatting = YES;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    return [dateFormatter stringFromDate:date];
}

@end
