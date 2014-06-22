//
//  NBConversationTableViewCell.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 23/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBConversationTableViewCell.h"
#import <UIImageView+MKNetworkKitAdditions.h>
#import "NSString+DataFormatting.h"
#import "NBTheme.h"
#import "NBCircleImageView.h"
#import "NBUser.h"

@interface NBConversationTableViewCell ()

@property (strong, nonatomic) IBOutlet NBCircleImageView *userImageView;
@property (strong, nonatomic) IBOutlet NBBoldLabel *userLabel;
@property (strong, nonatomic) IBOutlet NBBoldLabel *dateTimeLabel;
@property (strong, nonatomic) IBOutlet NBLabel *lastMessageContentLabel;
@end


@implementation NBConversationTableViewCell

#pragma mark - Public methods

- (void)configureWithConversation:(NBConversation *)conversation
{
    NBUser *user = conversation.recipient;
    NBMessage *lastestMessage = conversation.latestMessages.lastObject;
    
    [self configureImageViewWithUser:user];
    [self configureUserLabelWithUser:user];
    [self configureDateTimeLabelWithDateTime:lastestMessage.dateTime];
    [self configureMessageContentLabelWithMessage:lastestMessage];
}

#pragma mark - NBTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NBTheme *theme = [NBTheme sharedTheme];
    self.dateTimeLabel.textColor = theme.lightGreenColor;
}

- (void)setHighlighted:(BOOL)highlighted
{ }

#pragma mark - Convenience methods

- (void)configureImageViewWithUser:(NBUser *)user
{
    [self.userImageView setImageFromURL:user.avatarThumbnailURL
                       placeHolderImage:[UIImage imageNamed:@"img-avatar"]];
}

- (void)configureUserLabelWithUser:(NBUser *)user
{
    self.userLabel.text = user.username;
}

- (void)configureDateTimeLabelWithDateTime:(NSDate *)date
{
    self.dateTimeLabel.text = [NSString stringForDate:date];
}

- (void)configureMessageContentLabelWithMessage:(NBMessage *)message
{
    self.lastMessageContentLabel.text = message.content;
}

@end
