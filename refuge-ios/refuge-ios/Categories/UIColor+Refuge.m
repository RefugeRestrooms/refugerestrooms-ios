//
//  UIColor+Refuge.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/7/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "UIColor+Refuge.h"

@implementation UIColor (Refuge)

# pragma mark - Public methods

+ (UIColor *)RefugePurpleDarkColor
{
    return [UIColor colorWithRed:65.0/255.0 green:50.0/255.0 blue:107.0/255.0 alpha:1.0];
}

+ (UIColor *)RefugePurpleMediumColor
{
    return [UIColor colorWithRed:131.0/255.0 green:119.0/255.0 blue:175.0/255.0 alpha:1.0];
}

+ (UIColor *)RefugePurpleLightColor
{
    return [UIColor colorWithRed:229.0/255.0 green:215.0/255.0 blue:236.0/255.0 alpha:1.0];
}

+ (UIColor *)RefugeRatingNegativeColor
{
    return [UIColor colorWithRed:220.0/255.0 green:129.0/255.0 blue:137.0/255.0 alpha:1.0];
}

+ (UIColor *)RefugeRatingNeutralColor
{
    return [UIColor colorWithRed:226.0/255.0 green:224.0/255.0 blue:155.0/255.0 alpha:1.0];
}

+ (UIColor *)RefugeRatingNoneColor
{
    return [self RefugePurpleMediumColor];
}

+ (UIColor *)RefugeRatingPositiveColor
{
    return [UIColor colorWithRed:162.0/255.0 green:210.0/255.0 blue:147.0/255.0 alpha:1.0];
}

@end
