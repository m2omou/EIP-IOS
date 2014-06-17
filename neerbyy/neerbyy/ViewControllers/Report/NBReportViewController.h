//
//  NBReportViewController.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBGenericFormViewController.h"

@interface NBReportViewController : NBGenericFormViewController

@property (strong, nonatomic) NSNumber *identifierToReport;
@property (assign, nonatomic) SEL operationCreator;

@end
