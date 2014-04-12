//
//  NBAPINetworkOperation+UIImage.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 12/04/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBAPINetworkOperation+UIImage.h"

@implementation NBAPINetworkOperation (UIImage)

- (void)addImage:(UIImage *)image withKey:(NSString *)key mainKey:(NSString *)mainKey
{
    if (mainKey)
        key = [NSString stringWithFormat:@"%@[%@]", mainKey, key];
    
    NSString *extension = @"png";
    NSString *mimeType = [@"image" stringByAppendingPathComponent:extension];
    NSString *fileName = [key stringByAppendingPathExtension:extension];
    NSData *imageData = UIImagePNGRepresentation(image);
    [self addData:imageData forKey:key mimeType:mimeType fileName:fileName];
}

@end
