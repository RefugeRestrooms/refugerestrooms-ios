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
    NSURLConnection *fetchingConnection;
}

- (BOOL)wasAskedToFetchRestrooms
{
    return wasAskedToFetchRestrooms;
}

- (NSURL *)URLToFetch
{
    return fetchingURL;
}

- (NSURLConnection *)currentURLConnection
{
    return fetchingConnection;
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
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fetchingURL];
    
    fetchingConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)cancelAndDiscardURLConnection
{
    [fetchingConnection cancel];
    fetchingConnection = nil;
}

@end
