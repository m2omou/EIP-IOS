//
//  NBCommentTableViewCell.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBCommentTableViewCell.h"
#import <UIImageView+MKNetworkKitAdditions.h>
#import "NBCircleImageView.h"
#import "NBTheme.h"
#import "NBUser.h"

@interface NBCommentTableViewCell ()

@property (strong, nonatomic) IBOutlet NBCircleImageView *userImageView;
@property (strong, nonatomic) IBOutlet NBLabel *commentLabel;
@property (strong, nonatomic) IBOutlet NBLabel *usernameLabel;

@end


@implementation NBCommentTableViewCell

#pragma mark - Public methods

+ (CGFloat)heightForComment:(NBComment *)comment width:(CGFloat)width
{
    static CGFloat const minimumHeight = 81.f;
    static CGFloat const totalPadding = 50.f;

    CGFloat labelHeight = CGRectGetHeight([comment.content boundingRectWithSize:CGSizeMake(width, 0)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName: [[NBTheme sharedTheme].font fontWithSize:15.f]}
                                                                        context:nil]);
    CGFloat height = labelHeight + totalPadding;
    
    return MAX(minimumHeight, height);
}

- (void)configureWithComment:(NBComment *)comment
{
    [self.userImageView setImageFromURL:comment.author.avatarThumbnailURL placeHolderImage:[UIImage imageNamed:@"img-avatar"]];
    self.commentLabel.text = comment.content;
    self.usernameLabel.text = comment.author.username;
}

#pragma mark - NBTableViewCell

- (void)setHighlighted:(BOOL)highlighted
{
}

@end
