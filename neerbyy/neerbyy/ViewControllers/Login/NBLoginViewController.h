//
//  NBLoginViewController.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 24/01/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBGenericFormViewController.h"


@interface NBLoginViewController : NBGenericFormViewController

- (void)connectWithUsername:(NSString *)username password:(NSString *)password;

@end
