//
//  NBReportPublication.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/05/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBReportPublication.h"

#pragma mark - Constants

static NSString * const kNBReportKeyPublicationIdentifier = @"publication_id";

#pragma mark -

@implementation NBReportPublication

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.publicationId = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBReportKeyPublicationIdentifier];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:self.publicationId forKey:kNBReportKeyPublicationIdentifier];
}

#pragma mark - Properties

- (NBReportPublicationReason)reasonValue
{
    return self.reason.integerValue;
}

@end
