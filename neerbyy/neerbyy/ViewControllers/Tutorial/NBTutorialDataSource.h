//
//  NBTutorialDataSource.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 08/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBTutorialContent : NSObject

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *text;

@end

@interface NBTutorialDataSource : NSObject

- (NSUInteger)numberOfPages;
- (NBTutorialContent *)contentForPage:(NSUInteger)page;

@end
