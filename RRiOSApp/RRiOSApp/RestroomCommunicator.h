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
}

@property (weak) id <RestroomCommunicatorDelegate> delegate;

- (void)searchForRestroomsModifiedSince:(NSDate *)date;
- (void)cancelAndDiscardURLConnection;
//
//- (void)searchForRestroomsWithQuery:(NSString *)query;
//- (void)searchForRestroomsOfAmount:(NSInteger)numberRestrooms;

@end
