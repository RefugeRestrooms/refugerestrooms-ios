//
//  RestroomCommunicator.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RestroomCommunicatorDelegate.h"

#pragma message "It seems that this interface contains too much information that should not be public. You could move all of the non-public information into a separate header file. In my understanding 'searchForRestroomsWithQuery' and 'cancelAndDiscardURLConnection' are the only truly public methods"

@interface RestroomCommunicator : NSObject <NSURLConnectionDelegate>
{
    @protected NSURL *fetchingURL;
    NSURLConnection *fetchingConnection;
    NSMutableData *receivedData;
    
    @private id <RestroomCommunicatorDelegate> __weak delegate;
    void (^errorHandler)(NSError *);        // block for error handling
    void (^successHandler)(NSString *);     // block for success handling
}

- (void)searchForRestroomsWithQuery:(NSString *)query;
- (void)cancelAndDiscardURLConnection;

//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

@end
