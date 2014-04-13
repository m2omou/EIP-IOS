//
//  NBPublicationTableViewCell.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBTableViewCell.h"
@class NBPublication;


@interface NBPublicationTableViewCell : NBTableViewCell

- (void)configureWithPublication:(NBPublication *)publication;

@end
