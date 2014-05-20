//
//  NBReport.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/05/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBReport.h"

#pragma mark - Constants

static NSString * const kNBReportKeyIdentifier = @"id";
static NSString * const kNBReportKeyReason = @"reason";
static NSString * const kNBReportKeyContent = @"content";

#pragma mark -

@implementation NBReport

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.identifier = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBReportKeyIdentifier];
        self.reason = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBReportKeyReason];
        self.content = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBReportKeyContent];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:kNBReportKeyIdentifier];
    [aCoder encodeObject:self.reason forKey:kNBReportKeyReason];
    [aCoder encodeObject:self.content forKey:kNBReportKeyContent];
}

@end
