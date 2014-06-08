//
//  NBTutorialCell.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 08/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBTutorialDataSource.h"

@interface NBTutorialCell : UICollectionViewCell

- (void)configureWithContent:(NBTutorialContent *)content;

@end
