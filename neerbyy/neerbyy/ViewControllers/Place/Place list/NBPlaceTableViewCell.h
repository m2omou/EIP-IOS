//
//  NBPlaceTableViewCell.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBTableViewCell.h"
#import "NBPlace.h"

@interface NBPlaceTableViewCell : NBTableViewCell

- (void)configureWithPlace:(NBPlace *)place;

@end
