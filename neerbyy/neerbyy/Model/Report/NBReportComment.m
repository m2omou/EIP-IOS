//
//  NBReportComment.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/05/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBReportComment.h"

#pragma mark - Constants

static NSString * const kNBReportKeyCommentIdentifier = @"comment_id";

#pragma mark -

@implementation NBReportComment

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.commentId = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBReportKeyCommentIdentifier];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.commentId forKey:kNBReportKeyCommentIdentifier];
}

#pragma mark - Properties

- (NBReportCommentReason)reasonValue
{
    return self.reason.integerValue;
}

@end
