//
//  NBButton.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 24/01/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

@interface NBButton : UIButton

- (void)setTitleColors:(NSArray *)colors forStates:(NSArray *)states;

@end


@interface NBPrimaryButton : NBButton

@end


@interface NBSecondaryButton : NBButton

@end


@interface NBTextButton : NBButton

@end
