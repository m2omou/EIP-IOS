//
//  NBAbstractModel.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 01/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBAPI.h"

@interface NBAbstractModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

- (id)data:(id)data ofType:(Class)class;

- (NSDictionary *)dictionaryWithModel;

@end
