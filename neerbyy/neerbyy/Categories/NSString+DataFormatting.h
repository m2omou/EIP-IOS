//
//  NSString+DataFormatting.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 01/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NSString (DataFormatting)

+ (NSString *)stringForDistance:(CLLocationDistance)distance prefix:(NSString *)string;

@end
