//
//  NBReport.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/05/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

typedef enum : NSUInteger {
    kNBReportTypeCustom                 = 0,
    kNBReportTypeCopyrights             = 1,
    kNBReportTypeImageRights            = 2,
    kNBReportTypeInappropriateContent   = 3,
    kNBReportTypeDesriminatoryContent   = 4
} NBReportType;

@interface NBReport : NSObject <NSCoding>

+ (NSArray *)reportReasons;

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSNumber *reason;
@property (strong, nonatomic) NSString *content;

@end
