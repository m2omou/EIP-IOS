//
//  NBComment.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 11/05/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBComment.h"
#import "NBDictionaryDecoder.h"
#import "NBUser.h"

#pragma mark - Constants

static NSString * const kNBCommentKeyID = @"id";
static NSString * const kNBCommentKeyContent = @"content";
static NSString * const kNBCommentKeyAuthor = @"author";

#pragma mark -

@interface NBComment ()

@property (strong, nonatomic) NSDictionary *authorDictionary;

@end

@implementation NBComment

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.identifier = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kNBCommentKeyID];
        self.content = [aDecoder decodeObjectOfClass:[NSString class] forKey:kNBCommentKeyContent];
        self.authorDictionary = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:kNBCommentKeyAuthor];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:kNBCommentKeyID];
    [aCoder encodeObject:self.content forKey:kNBCommentKeyContent];
    [aCoder encodeObject:self.authorDictionary forKey:kNBCommentKeyAuthor];
}

#pragma mark - Properties

- (NBUser *)author
{
    if (!self.authorDictionary.allKeys.count)
        return nil;
    
    NBDictionaryDecoder *userDecoder = [NBDictionaryDecoder dictonaryCoderWithData:self.authorDictionary];
    return [[NBUser alloc] initWithCoder:userDecoder];
}

@end
