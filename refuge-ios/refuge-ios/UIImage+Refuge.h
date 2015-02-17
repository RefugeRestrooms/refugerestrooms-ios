//
//  UIImage+Refuge.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/11/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Refuge)

+ (UIImage *)resizeImageNamed:(NSString *)imageName width:(CGFloat)width height:(CGFloat)height;

@end
