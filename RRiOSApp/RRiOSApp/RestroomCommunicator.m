//
//  RestroomCommunicator.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RestroomCommunicator.h"

static NSString *apiURLStub = @"http://www.refugerestrooms.org:80/api/v1/restrooms/search.json";

@implementation RestroomCommunicator
{
    BOOL wasAskedToFetchRestrooms;
    NSURL *fetchingURL;
}

- (BOOL)wasAskedToFetchRestrooms
{
    return wasAskedToFetchRestrooms;
}

- (NSURL *)URLToFetch
{
    return fetchingURL;
}

- (void)searchForRestroomsWithQuery:(NSString *)query
{
    // set flag
    wasAskedToFetchRestrooms = YES;
    
    NSString *escapedQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self fetchContentAtURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?query=%@", apiURLStub, escapedQuery]]];
}

- (void)fetchContentAtURL:(NSURL *)url
{
    fetchingURL = url;
}

@end
