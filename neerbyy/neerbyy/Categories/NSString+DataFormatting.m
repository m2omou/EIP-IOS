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
    if (distance == CLLocationDistanceMax || distance == 0.0f)
        return NSLocalizedString(@"Distance indéterminée", @"Distance indéterminée");
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.minimumIntegerDigits = 1;
    numberFormatter.minimumFractionDigits = 0;
    numberFormatter.maximumFractionDigits = 1;
    numberFormatter.secondaryGroupingSize = 3;

    NSString *distanceUnit;
    if (distance > 1000)
    {
        if (distance > 1000000)
            numberFormatter.maximumFractionDigits = 0;
        
        distance /= 1000;
        distanceUnit = @"km";
    }
    else
    {
        distanceUnit = @"m";
        numberFormatter.maximumFractionDigits = 0;
    }
    
    NSString *distanceString = [numberFormatter stringFromNumber:@(distance)];
    return [NSString stringWithFormat:@"%@%@ %@", prefix, distanceString, distanceUnit];
}

+ (NSString *)stringForDate:(NSDate *)date
{
    if (date == nil)
        return NSLocalizedString(@"Date indéterminée", @"Date indéterminée");
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.doesRelativeDateFormatting = YES;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    return [dateFormatter stringFromDate:date];
}

@end
