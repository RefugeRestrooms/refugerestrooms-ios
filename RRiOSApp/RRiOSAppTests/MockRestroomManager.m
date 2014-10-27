//
//  MockRestroomManager.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 10/1/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "MockRestroomManager.h"

@implementation MockRestroomManager

@synthesize delegate;

- (NSInteger)restroomFailureErrorCode
{
    return restroomFailureErrorCode;
}
- (void)searchingForRestroomsFailedWithError:(NSError *)error
{
    restroomFailureErrorCode = [error code];
}

- (void)receivedRestroomsJSONString:(NSString *)jsonString
{
    restroomSearchString = jsonString;
}

- (NSString *)restroomSearchString
{
    return restroomSearchString;
}

- (BOOL)didFetchRestrooms
{
    return wasAskedToFetchRestrooms;
}

- (void)fetchRestroomsForQuery:(NSString *)query
{
    wasAskedToFetchRestrooms = YES;
}

@end
