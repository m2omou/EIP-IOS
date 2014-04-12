//
//  NBMenuTableViewCell.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBTheme.h"
#import "NBMenuTableViewCell.h"


@implementation NBMenuTableViewCell

- (void)setHighlighted:(BOOL)highlighted
{
    NBTheme *theme = [NBTheme sharedTheme];
    
    if (highlighted)
        self.textLabel.textColor = theme.lightGreenColor;
    else
        self.textLabel.textColor = theme.darkGrayColor;
    
    self.imageView.highlighted = highlighted;
}

@end
