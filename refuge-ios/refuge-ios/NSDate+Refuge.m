//
//  NSDate+Refuge.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "NSDate+Refuge.h"

static NSString * const kRefgueDateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

@implementation NSDate (Refuge)

+ (NSString *)dateFormat
{
    return kRefgueDateFormat;
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    return [self.dateFormatter dateFromString:dateString];
}

# pragma mark - Helper methods

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = kRefgueDateFormat;
    
    return dateFormatter;
}

@end
