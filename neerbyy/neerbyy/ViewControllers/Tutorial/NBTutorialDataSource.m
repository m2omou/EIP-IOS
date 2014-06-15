//
//  NBTutorialDataSource.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 08/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBTutorialDataSource.h"

@implementation NBTutorialContent

+ (NBTutorialContent *)tutorialContentWithImage:(UIImage *)image text:(NSString *)text
{
    NBTutorialContent *tutorialContent = [NBTutorialContent new];
    tutorialContent.image = image;
    tutorialContent.text = text;
    return tutorialContent;
}

@end

@interface NBTutorialDataSource ()

@property (strong, nonatomic) NSArray *tutorialPages;

@end

@implementation NBTutorialDataSource

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tutorialPages = @[
                               [NBTutorialContent tutorialContentWithImage:[UIImage imageNamed:@"tuto-lieux"] text:@"Bienvenue dans Neerbyy\n\nRetrouvez les lieux qui vous sont chers..."],
                               [NBTutorialContent tutorialContentWithImage:[UIImage imageNamed:@"tuto-souvenirs"] text:@"Souvenirs\n\nVisionnez les souvenirs qu'y ont publié les autres utilisateurs..."],
                               [NBTutorialContent tutorialContentWithImage:[UIImage imageNamed:@"tuto-nouveau-souvenir"] text:@"Partage\n\n... et ajoutez les votres !"],
                               [NBTutorialContent tutorialContentWithImage:[UIImage imageNamed:@"tuto-commentaire"] text:@"Commentez, aimez, partagez !\n\nA vous de jouer."],
                               ];
    }
    
    return self;
}

- (NSUInteger)numberOfPages
{
    return self.tutorialPages.count;
}

- (NBTutorialContent *)contentForPage:(NSUInteger)page
{
    NSAssert(page < self.numberOfPages, @"page %@ is not a valid page number", @(page));
    return self.tutorialPages[page];
}

@end
