//
//  NBReport.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/05/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

@interface NBReport : NSObject <NSCoding>

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSNumber *reason;
@property (strong, nonatomic) NSString *content;

@end
