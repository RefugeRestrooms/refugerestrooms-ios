//
//  RestroomCommunicator.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RestroomCommunicator.h"

@implementation RestroomCommunicator
{
    BOOL wasAskedToFetchRestrooms;
}

- (void)searchForRestroomsWithQuery:(NSString *)query
{
    wasAskedToFetchRestrooms = YES;
}

- (BOOL)wasAskedToFetchRestrooms
{
    return wasAskedToFetchRestrooms;
}

@end
