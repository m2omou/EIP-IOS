//
//  NBTableViewCell.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBTableViewCell.h"
#import "NBTheme.h"


@implementation NBTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NBTheme *theme = [NBTheme sharedTheme];

    self.backgroundColor = theme.lightGrayColor;
    self.textLabel.font = [theme.font fontWithSize:self.textLabel.font.pointSize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self setHighlighted:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted)
        [self setHighlighted:highlighted];
    else
    {
        [UIView animateWithDuration:0.1f animations:^{
            [self setHighlighted:highlighted];
        }];
    }
}

@end
