//
//  NBTutorialCell.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 08/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBTutorialCell.h"
#import "NBCircleImageView.h"
#import "NBLabel.h"
#import "NBTheme.h"

@interface NBTutorialCell ()

@property (strong, nonatomic) IBOutlet NBCircleImageView *imageView;
@property (strong, nonatomic) IBOutlet NBLabel *textLabel;

@end

@implementation NBTutorialCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NBTheme *theme = [NBTheme sharedTheme];

    self.imageView.layer.borderColor = [theme.lightGreenColor colorWithAlphaComponent:.8f].CGColor;
    self.imageView.layer.borderWidth = 4.f;
}

- (void)configureWithContent:(NBTutorialContent *)content
{
    self.imageView.image = content.image;
    
    NBTheme *theme = [NBTheme sharedTheme];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 5.f;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle,
                                 NSForegroundColorAttributeName: theme.whiteColor};

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content.text attributes:attributes];
    self.textLabel.attributedText = attributedString;
}

@end
