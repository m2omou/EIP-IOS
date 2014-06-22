//
//  NBMessageTableViewCell.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBTableViewCell.h"
#import "NBMessage.h"

@interface NBMessageTableViewCell : NBTableViewCell

+ (CGFloat)heightForMessage:(NBMessage *)message width:(CGFloat)width;

- (void)configureWithMessage:(NBMessage *)message;

@end
