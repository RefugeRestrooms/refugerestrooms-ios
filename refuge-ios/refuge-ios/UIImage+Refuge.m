//
//  UIImage+Refuge.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/11/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "UIImage+Refuge.h"

@implementation UIImage (Refuge)

+ (UIImage *)resizeImageNamed:(NSString *)imageName width:(CGFloat)width height:(CGFloat)height
{
    CGSize newSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(newSize);
    [[UIImage imageNamed:imageName] drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end
