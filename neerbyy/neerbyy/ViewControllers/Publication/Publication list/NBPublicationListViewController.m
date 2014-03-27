//
//  NBPublicationListViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 22/03/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPublicationListViewController.h"
#import "NBPublicationTableViewCell.h"


#pragma mark - Constants

static NSString * const kNBPublicationCellIdentifier = @"NBPublicationTableViewCellIdentifier";

#pragma mark -


@interface NBPublicationListViewController ()

@end


@implementation NBPublicationListViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.publications = @[@{@"description":@"L'arrivée du tour de France 1995 en vidéo. Miguel Indurain n'a pas gagné l'étape, mais il a gagné le tour !",
                            @"smallText": @"LAmstrong @Champs-Élysées",
                            @"img":@"tdf"},
                          @{@"description":@"L'investiture de Nicolas Sarkozy en 2007",
                            @"smallText": @"Stoows @Élysée",
                            @"img":@"sarko"},
                          @{@"description":@"Probablement la photo la plus romantique que j'ai pu voir.",
                            @"smallText": @"Wass @Tour Eiffel",
                            @"img":@"chinois"},
                          @{@"description":@"Hier, au Starbucks rue St Catherine, on profitait tranquillement de notre café quand un putain de roumain est venu nous vendre des roses. Du coup, je lui ai pissé à la raie.",
                            @"smallText": @"JP @Starbucks Coffee",
                            @"img":@"text"},
                          @{@"description":@"L'explosion de joie du Stade après la victore en 98. Tout simplement magique",
                            @"smallText": @"ZiZou @Stade de France",
                            @"img":@"edf"}
                          ];
    
    self.reuseIdentifier = kNBPublicationCellIdentifier;
    self.onConfigureCell = ^(NBPublicationTableViewCell *cell, id associatedPublication, NSUInteger dataIdx)
    {
        [cell configureWithPublication:associatedPublication];
    };
}

#pragma mark - Properties

- (void)setPublications:(NSArray *)publications
{
    self.data = publications;
}

- (NSArray *)publications
{
    return self.data;
}

@end
