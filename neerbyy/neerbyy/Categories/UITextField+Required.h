//
//  UITextField+Required.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 01/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

@interface UITextField (Required)

@property (assign, nonatomic) BOOL isRequired;
@property (readonly, nonatomic) BOOL canReturn;

@end
