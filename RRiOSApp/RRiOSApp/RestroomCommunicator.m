//
//  RestroomCommunicator.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "Constants.h"
#import "RestroomCommunicator.h"

static NSString *RestroomCommunicatorErrorDomain = @"RestroomCommunicatorErrorDomain";

@implementation RestroomCommunicator
{
    void (^errorHandler)(NSError *);        // block for error handling
    void (^successHandler)(NSString *);     // block for success handling
}

- (void)dealloc
{
    [fetchingConnection cancel];
}

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
    
    [self fetchContentAtURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?per_page=100&query=%@", API_CALL_SEARCH_RESTROOMS, escapedQuery]]
               errorHandler:^(NSError *error) {
                   [self.delegate searchingForRestroomsFailedWithError:error];
               }
             successHandler:^(NSString *jsonString) {
                 [self.delegate receivedRestroomsJSONString:jsonString];
             }
     ];
}

- (void)searchForRestroomsOfAmount:(NSInteger)numberRestrooms
{
    // create fetch URl and fetch
    [self fetchContentAtURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?per_page=%i", API_CALL_ALL_RESTROOMS, numberRestrooms]]
               errorHandler:^(NSError *error) {
                   [self.delegate searchingForRestroomsFailedWithError:error];
               }
             successHandler:^(NSString *jsonString) {
                 [self.delegate receivedRestroomsJSONString:jsonString];
             }
     ];
}

 - (void)searchForRestroomsModifiedSince:(NSDate *)date;
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* dateComponents = [gregorianCalendar components:NSCalendarUnitDay fromDate:date];
    
//    NSString *day = [NSString stringWithFormat:@"%i", [dateComponents day]];
//    NSString *month = [NSString stringWithFormat:@"%i", [dateComponents month]];
//    NSString *year = [NSString stringWithFormat:@"%i", [dateComponents year]];

    int day = [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:date] day];
    int month = [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:date] month];
    int year = [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date] year];
    
    // TODO: remove test data!
    day = 1;
    month = 11;
    year = 2014;
    
    // create fetch URl and fetch
    [self fetchContentAtURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?day=%i&month=%i&year=%i", API_CALL_BY_DATE_RESTROOMS, day, month, year]]
               errorHandler:^(NSError *error) {
                   [self.delegate searchingForRestroomsFailedWithError:error];
               }
             successHandler:^(NSString *jsonString) {
                 [self.delegate receivedRestroomsJSONString:jsonString];
             }
     ];
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
    NSLog(@"Data: %@", data);
    
    [receivedData appendData:data];
}

@end
