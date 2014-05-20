//
//  NBReportComment.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/05/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBReport.h"

typedef NS_ENUM(NSUInteger, NBReportCommentReason) {
    kNBReportCommentReasonOther = 0
};

@interface NBReportComment : NBReport

@property (strong, nonatomic) NSNumber *commentId;
@property (readonly, nonatomic) NBReportCommentReason reasonValue;

@end
