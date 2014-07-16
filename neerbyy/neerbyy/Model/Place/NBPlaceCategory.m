//
//  NBPlaceCategory.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 26/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPlaceCategory.h"

#pragma mark - Constants

static NSString * const kNBCategoryKeyIdentifier = @"id";
static NSString * const kNBCategoryKeyDescription = @"name";

#pragma mark -

@implementation NBPlaceCategory

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.identifier = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBCategoryKeyIdentifier];
        self.description = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBCategoryKeyDescription];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:kNBCategoryKeyIdentifier];
    [aCoder encodeObject:self.description forKey:kNBCategoryKeyDescription];
}

@end
