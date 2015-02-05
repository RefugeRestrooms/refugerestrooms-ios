//
//  NSDate+Refuge.h
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Refuge)

+ (NSString *)dateFormat;
+ (NSDate *)dateFromString:(NSString *)dateString;

@end
