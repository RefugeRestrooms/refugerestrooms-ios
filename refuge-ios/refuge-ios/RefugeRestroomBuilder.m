//
//  RefugeRestroomBuilder.m
//  refuge-ios
//
//  Created by Harlan Kellaway on 2/4/15.
//  Copyright (c) 2015 Refuge Restrooms. All rights reserved.
//

#import "RefugeRestroomBuilder.h"

#import "NSDate+Refuge.h"
#import "RefugeRestroom.h"

@implementation RefugeRestroomBuilder

- (NSArray *)buildRestroomsFromJSON:(id)jsonObjects error:(NSError *)error
{
    RefugeRestroom *restroom = [[RefugeRestroom alloc] init];
    
    restroom.identifier = [NSNumber numberWithInt:4327];
    restroom.name = @"Target";
    restroom.street = @"7900 Old Wake Forest Rd";
    restroom.city = @"Raleigh";
    restroom.state = @"NC";
    restroom.country = @"US";
    restroom.isAccessible = NO;
    restroom.isUnisex = YES;
    restroom.numUpvotes = 1;
    restroom.numDownvotes = 0;
    restroom.directions = @"There are single-stall bathrooms by the pharmacy, next to the deodorant aisle.";
    restroom.comment = @"This is the Target by Triangle Town Center.";
    restroom.createdDate = [NSDate dateFromString:@"2014-02-02T20:55:31.555Z"];
    
    NSArray *restroomsArray = [NSArray arrayWithObject:restroom];
    
    return restroomsArray;
}

@end
