//
//  NBCommentTableViewCell.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBTableViewCell.h"
#import "NBComment.h"

@interface NBCommentTableViewCell : NBTableViewCell

+ (CGFloat)heightForComment:(NBComment *)comment width:(CGFloat)width;

- (void)configureWithComment:(NBComment *)comment;

@end
