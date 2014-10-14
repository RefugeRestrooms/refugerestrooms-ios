//
//  RestroomManager.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RestroomManager.h"
#import "RestroomManagerDelegate.h"

@interface RestroomManager ()

- (void)tellDelegateAboutRestroomSearchError: (NSError *)underlyingError;

@end

@implementation RestroomManager

NSString *RestroomManagerSearchFailedError = @"RestroomManagerSearchFailedError";

- (void)setDelegate:(id<RestroomManagerDelegate>)newDelegate
{
    if (newDelegate && ![newDelegate conformsToProtocol: @protocol(RestroomManagerDelegate)])
    {
        [[NSException exceptionWithName: NSInvalidArgumentException reason: @"Delegate object does not conform to the delegate protocol." userInfo: nil] raise];
    }
    
    _delegate = newDelegate;
}

- (void)fetchRestroomsForQuery:(NSString *)query
{
    [self.communicator searchForRestroomsWithQuery:query];
}

#pragma mark - Helper methods

- (void)receivedRestroomsJSONString:(NSString *)jsonString
{
    NSError *error = nil;
    NSArray *restrooms = [self.restroomBuilder restroomsFromJSON:jsonString error:&error];
    
    if(!restrooms)
    {
        // underlying error
        [self searchingForRestroomsFailedWithError:error];
    }
    else
    {
        [self.delegate didReceiveRestrooms:restrooms];
    }
}


- (void)searchingForRestroomsFailedWithError:(NSError *)error
{
    [self tellDelegateAboutRestroomSearchError:error];
}

#pragma mark - Helper methods

- (void)tellDelegateAboutRestroomSearchError:(NSError *)underlyingError
{
    NSDictionary *errorInfo = nil;
    
    if (underlyingError)
    {
        errorInfo = [NSDictionary dictionaryWithObject:underlyingError forKey:NSUnderlyingErrorKey];
    }
    
    NSError *reportableError = [NSError errorWithDomain:RestroomManagerSearchFailedError code:RestroomManagerErrorSearchCode userInfo:errorInfo];

    [self.delegate fetchingRestroomsFailedWithError:reportableError];
}

@end