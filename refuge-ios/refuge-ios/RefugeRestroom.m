//
//  RefugeRestroom.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeRestroom.h"

#import "MTLJSONAdapter.h"
#import "MTLValueTransformer.h"
#import "NSDate+Refuge.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@implementation RefugeRestroom

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"id" : @"id",
             @"name" : @"name",
             @"street" : @"street",
             @"city" : @"city",
             @"state" : @"state",
             @"country" : @"country",
             @"isAccessible" : @"accessible",
             @"isUnisex" : @"unisex",
             @"numUpvotes" : @"downvote",
             @"numDownvotes" : @"upvote",
             @"directions" : @"directions",
             @"comment" : @"comment",
             @"createdDate" : @"created_at"
             };
}

+ (NSValueTransformer *)createdDateJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        NSDate *date = [NSDate dateFromString:str];
        return date;
    } reverseBlock:^(NSDate *date) {
        return [NSDate stringFromDate:date];
    }];
}

+ (NSValueTransformer *)latitudeJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *number) {
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } reverseBlock:^(NSDecimalNumber *decimalNumber) {
        return [NSNumber numberWithDouble:[decimalNumber doubleValue]];
    }];
}

+ (NSValueTransformer *)longitudeJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *number) {
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } reverseBlock:^(NSDecimalNumber *decimalNumber) {
        return [NSNumber numberWithDouble:[decimalNumber doubleValue]];
    }];
}

@end
