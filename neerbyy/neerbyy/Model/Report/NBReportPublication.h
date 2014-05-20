//
//  NBReportPublication.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/05/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBReport.h"

typedef NS_ENUM(NSUInteger, NBReportPublicationReason) {
    kNBReportPublicationReasonOther             = 0,
    kNBReportPublicationReasonCopyrights        = 1,
    kNBReportPublicationReasonImageRights       = 2,
    kNBReportPublicationReasonSexualContent     = 3
};

@interface NBReportPublication : NBReport

@property (strong, nonatomic) NSNumber *publicationId;
@property (readonly, nonatomic) NBReportPublicationReason reasonValue;

@end
