//
//  RestroomCommunicator.h
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RestroomCommunicatorDelegate.h"

@interface RestroomCommunicator : NSObject <NSURLConnectionDelegate>
{
    @protected
        NSURL *fetchingURL;
        NSURLConnection *fetchingConnection;
        NSMutableData *receivedData;
    
//    @private
//        void (^errorHandler)(NSError *);        // block for error handling
//        void (^successHandler)(NSString *);     // block for success handling
}

@property (weak) id <RestroomCommunicatorDelegate> delegate;

- (void)searchForRestroomsWithQuery:(NSString *)query;
- (void)searchForNewRestrooms;
- (void)searchForRestroomsOfAmount:(NSInteger)numberRestrooms;
- (void)cancelAndDiscardURLConnection;

// in here for tests to pass, currently
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

@end
