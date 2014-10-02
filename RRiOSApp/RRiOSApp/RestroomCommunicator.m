//
//  RestroomCommunicator.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RestroomCommunicator.h"

static NSString *apiURLStub = @"http://www.refugerestrooms.org:80/api/v1/restrooms/search.json";

NSString *RestroomCommunicatorErrorDomain = @"RestroomCommunicatorErrorDomain";

@implementation RestroomCommunicator

@synthesize delegate;

- (void)launchConnectionForRequest:(NSURLRequest *)request
{
    [self cancelAndDiscardURLConnection];
    
    fetchingConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)fetchContentAtURL: (NSURL *)url
             errorHandler: (void (^)(NSError *))errorBlock
           successHandler: (void (^)(NSString *))successBlock
{
    fetchingURL = url;
    errorHandler = [errorBlock copy];
    successHandler = [successBlock copy];
                
    NSURLRequest *request = [NSURLRequest requestWithURL:fetchingURL];
                
    [self launchConnectionForRequest:request];
}

- (void)searchForRestroomsWithQuery:(NSString *)query
{
    NSString *escapedQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self fetchContentAtURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?query=%@", apiURLStub, escapedQuery]]
               errorHandler:^(NSError *error) {
                   [delegate searchingForRestroomsFailedWithError:error];
               }
             successHandler:^(NSString *jsonString) {
                 [delegate receivedRestroomsJSONString:jsonString];
             }
     ];
}

- (void)dealloc
{
    [fetchingConnection cancel];
}

- (void)cancelAndDiscardURLConnection
{
    [fetchingConnection cancel];
    fetchingConnection = nil;
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receivedData = nil;
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if ([httpResponse statusCode] != 200)
    {
        NSError *error = [NSError errorWithDomain:RestroomCommunicatorErrorDomain code:[httpResponse statusCode] userInfo:nil];
        errorHandler(error);
        [self cancelAndDiscardURLConnection];
    }
    else
    {
        receivedData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    receivedData = nil;
    fetchingConnection = nil;
    fetchingURL = nil;
    errorHandler(error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    fetchingConnection = nil;
    fetchingURL = nil;
    NSString *receivedText = [[NSString alloc] initWithData: receivedData
                                                   encoding: NSUTF8StringEncoding];
    receivedData = nil;
    successHandler(receivedText);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

@end
