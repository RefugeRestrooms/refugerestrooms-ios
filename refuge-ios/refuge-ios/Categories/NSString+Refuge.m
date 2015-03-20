//
//  NSString+Refuge.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 3/19/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "NSString+Refuge.h"

@implementation NSString (Refuge)

- (instancetype)prepareForDisplay
{
    return [self stringByReplacingOccurrencesOfString:@"\\'" withString:@"\'"];
}

@end
